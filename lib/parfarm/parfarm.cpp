// parfarm.cpp

#include <octave/oct.h>
#include <octave/octave.h>
#include <octave/parse.h>
#include <octave/toplev.h>
#include <octave/builtin-defun-decls.h>
#include <octave/ls-oct-binary.h>

#include <iostream>
#include <ext/stdio_filebuf.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

/* Communication protocol:
   The FarmOut sends an octave_value that is a pair of integers specifying
   nargin and nargout.
   Following that, it sends an octave_value that is the name of a function
   to call.
   Following that are the nargin arguments to that function.
   
   Upon completion, the worker sends back an octave_value that is an
   integer specifying the number of following values, which may be zero.
   Each value is a return value from the command.
   Errors are indicated by a -1 value count.
 */

class Worker {
public:
  Worker(int fdInput, int fdResult);
  void run();
private:
  __gnu_cxx::stdio_filebuf<char> srcbuf, resbuf;
  std::ostream res;
  std::istream src;
private:
  void loop();
  bool readOValue(octave_value &);
  bool sendOValue(octave_value const &);
};

class FarmOut {
public:
  FarmOut(); // throws exception if cannot fork
  ~FarmOut(); // kills worker process
  inline int fdToWorker() { return fd[1]; }
  inline int fdFromWorker() { return fd[2]; }
  inline int worker_fdFromClient() { return fd[0]; }
  inline int worker_fdToClient() { return fd[3]; }
  inline std::ostream &toWorker() { return *tow; }
  inline std::istream &fromWorker() { return *fromw; }
  void sendInteger(int x);
  bool sendOValue(octave_value const &);
  bool receiveOValue(octave_value &);
  int receiveInteger();
private:
  int fd[4];
  pid_t pid;
  std::ostream *tow;
  std::istream *fromw;
  __gnu_cxx::stdio_filebuf<char> *tobuf, *frombuf;
};

FarmOut::FarmOut() {
  tow = 0;
  fromw = 0;
  tobuf = 0;
  frombuf = 0;
  pid = -1;
  fd[0] = fd[1] = fd[2] = fd[3] = -1;
  if (pipe(fd+0) || pipe(fd+2)) {
    perror("parfarm: Could not create pipes");
    if (fd[0]>=0)
      close(fd[0]);
    if (fd[1]>=0)
      close(fd[1]);
    throw std::exception();
  }
  pid = fork();
  if (pid<0) {
    // Error
    perror("parfarm: Could not fork");
    close(fd[0]);
    close(fd[1]);
    close(fd[2]);
    close(fd[3]);
    throw std::exception();
  } else if (pid==0) {
    // Worker (child)
    close(fdToWorker());
    close(fdFromWorker());
    std::cout << "Starting worker\n";
    try {
      Worker worker(worker_fdFromClient(), worker_fdToClient());
      worker.run();
      std::cout << "Worker returned\n";
      close(worker_fdFromClient());
      close(worker_fdToClient());
    } catch (std::exception) {
      std::cout << "Worker failed to run\n";
    }
    exit(0);
  } else {
    // Client (parent)
    close(worker_fdFromClient());
    close(worker_fdToClient());
    tobuf = new __gnu_cxx::stdio_filebuf<char>(fdToWorker(), std::ios::out);
    tow = new std::ostream(tobuf);
    frombuf = new __gnu_cxx::stdio_filebuf<char>(fdFromWorker(), std::ios::in);
    fromw = new std::istream(frombuf);
    return;
  }
}

FarmOut::~FarmOut() {
  delete tow;
  delete tobuf;
  delete fromw;
  delete frombuf;

  int status;
  int options = WNOHANG;
  for (int iter=0;; iter++) {
    pid_t res = waitpid(pid, &status, options);
    if (res==pid) {
      std::cout << "parfarm: Waitpid good\n";
      // all good
      return;
    } else if (res<0) {
      perror("parfarm: Waitpid failed. Aborting");
      abort();
    } else if (res>0) {
      std::cout << "parfarm: Waitpid mysterious: " << res << "\n";
      abort();
    } else {
      switch (iter) {
      case 0: {
        std::cout << "parfarm: Closing sending pipe and waiting for return to close...\n";
        close(fdToWorker());
        int n = sleep(1); // This will probably be interrupt by child exiting
      } break;
      case 1:
        std::cout << "parfarm: Worker still running. Sending terminate signal.\n";
        kill(pid, SIGTERM);
        sleep(2);
        break;
      case 2:
        std::cout << "parfarm: Worker still running. Sending kill signal.\n";
        kill(pid, SIGKILL);
        sleep(2);
        break;
      case 3:
        std::cout << "parfarm: Worker still running. One more chance.\n";
        sleep(2);
        break;
      default:
        std::cout << "parfarm: Worker still running. Aborting.\n";
        abort();
        break;
      }
    }
  }
}

bool FarmOut::sendOValue(octave_value const &x) {
  static std::string name = "x";
  static std::string doc = "x";
  return save_binary_data(toWorker(), x, name, doc, false, false);
}

bool FarmOut::receiveOValue(octave_value &x) {
  static std::string fn = "y";
  static std::string name;
  static std::string doc;
  bool glb;
  name = read_binary_data(fromWorker(), false,
                          oct_mach_info::flt_fmt_ieee_little_endian,
                          fn, glb,
                          x, doc);
  return name!="";
}

void FarmOut::sendInteger(int x) {
  try {
    toWorker() << x << "\n";
    toWorker().flush();
  } catch (std::exception) {
    perror("parfarm: Failed to write");
  }
}

int FarmOut::receiveInteger() {
  int x;
  try {
    fromWorker() >> x;
    return x;
  } catch (std::exception) {
    perror("parfarm: Failed to read");
    return -1;
  }
}

//////////////////////////////////////////////////////////////////////

Worker::Worker(int fdInputs, int fdResults):
  srcbuf(fdInputs, std::ios::in), resbuf(fdResults, std::ios::out),
  src(&srcbuf), res(&resbuf) {
}  

void Worker::run() {
  // Since we forked from octave, we already have an octave interpreter.
  // All we have to do is clear its workspace:
  Fclear();

  // Let's accept commands
  Worker::loop();

  // Clean up: close pipes and quit local octave
  std::cout << "Worker cleaning up\n";
  clean_up_and_exit(0, true);
}

void Worker::loop() {
  std::string fn = "x";
  std::string name;
  std::string doc;
  bool glb;
  while (src.good() && res.good()) {
    std::cout << "Worker ready\n";
    octave_value buf;
    name = read_binary_data(src, false,
                            oct_mach_info::flt_fmt_ieee_little_endian,
                            fn, glb,
                            buf, doc);
    if (name=="")
      return;
    int32NDArray nn = buf.int32_array_value();
    int nargin = nn(0,0);
    int nargout = nn(0,1);
    if (nargin<0 || nargout<0) 
      return;
      

    octave_value foo;
    octave_value_list args(nargin);
    name = read_binary_data(src, false,
                            oct_mach_info::flt_fmt_ieee_little_endian,
                            fn, glb,
                            foo, doc);
    if (name=="") {
      std::cout << "Worker: Failed to read function name\n";
      return;
    }
    for (int k=0; k<nargin; k++) {
      name = read_binary_data(src, false,
                              oct_mach_info::flt_fmt_ieee_little_endian,
                              fn, glb,
                              args(k), doc);
      if (name=="") {
        std::cout << "Worker: Failed to read arguments";
        return;
      }
    }

    std::cout << "Will evaluate '" << foo.string_value() << "'\n";
    octave_value_list ovl = feval(foo.string_value(), args, nargout);

    bool ok = !error_state && ovl.length()==nargout;
    error_state = 0; // needed?

    dim_vector dvx(1,1);
    int32NDArray x(dvx);
    x(0,0) = ok ? nargout : -1;
    octave_value ov(x);
    
    if (!save_binary_data(res, ov, name, doc, false, false)) {
      std::cout << "Worker: Failed to send count\n";
      return;
    }

    if (ok) {
      for (int k=0; k<nargout; k++) {
        if (!save_binary_data(res, ovl(k), name, doc, false, false)) {
          std::cout << "Worker: Failed to send result\n";
          return;
        }
      }
    }
    
    res.flush();
  }
}
  

DEFUN_DLD (parfarm, args, nargout, "Parallel Farm") {
  static FarmOut *farmout = 0;
  int nout = nargout>0 ? nargout : 1;

  dim_vector dv(1, nout);
  octave_value_list out(dv);
  
  if (args.length()==0) {
    std::cout << "parfarm: Deleting farmout.\n";
    delete farmout;
    std::cout << "parfarm: Farmout deleted.\n";
    farmout = 0;
    return out;
  }
  
  if (farmout==0) {
    try {
      farmout = new FarmOut();
    } catch (std::exception) {
      std::cout << "parfarm: Failed to start farmout\n";
      return out;
    }
  }

  dim_vector dvx(1,2);
  int32NDArray x(dvx);
  x(0,0) = args.length()-1;
  x(0,1) = nout;
  octave_value ov = x;
  
  bool r = farmout->sendOValue(ov);
  if (!r) {
    std::cout << "parfarm: failed to send count\n";
    return out;
  }
  for (int k=0; k<args.length(); k++) {
    if (!farmout->sendOValue(args(k))) {
      std::cout << "parfarm: failed to send data\n";
      return out;
    }
  }
  farmout->toWorker().flush();
  
  r = farmout->receiveOValue(ov);
  if (!r) {
    std::cout << "parfarm: failed to receive count\n";
    return out;
  }
  
  x = ov.int32_array_value();
  int n = x(0,0);

  //  std::cout << "parfarm: received " << n << "\n";
  
  if (n<0) {
    std::cout << "parfarm: Result indicates error\n";
    return out;
  }
  
  if (n>nout)
    n = nout;
  for (int k=0; k<n; k++) {
    r = farmout->receiveOValue(out(k));
    if (!r) {
      std::cout << "parfarm: Failed to receive results\n";
      out = octave_value_list(nout);
      return out;
    }
  }
  return out;
}
