// parfarm.cpp

#include <octave/oct.h>
#include <octave/octave.h>
#include <octave/parse.h>
#include <octave/toplev.h>
#include <octave/builtin-defun-decls.h>
#include <octave/ls-oct-binary.h>
#include <octave/Cell.h>

#include <iostream>
#include <ext/stdio_filebuf.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>

#define PARFARM_VERBOSE 0

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

struct timeval tv0;
struct timezone tz;
void settime0() {
  gettimeofday(&tv0, &tz);
}

void reporttime(char const *msg) {
  struct timeval tv;
  gettimeofday(&tv, &tz);
  double us = tv.tv_usec/1e6 - tv0.tv_usec/1e6;
  us += tv.tv_sec/1.0 - tv0.tv_sec/1.0;
  printf("%12.6f %s\n", us, msg);
}

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
#if PARFARM_VERBOSE
    std::cout << "Starting worker\n";
#endif
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
#if PARFARM_VERBOSE
      std::cout << "parfarm: Waitpid good\n";
#endif
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
#if PARFARM_VERBOSE
        std::cout << "parfarm: Closing sending pipe and waiting for return to close...\n";
#endif
        close(fdToWorker());
        int n = usleep(50000); // This will probably be interrupt by child exiting
      } break;
      case 1:
        std::cout << "parfarm: Worker still running. Sending terminate signal.\n";
        kill(pid, SIGTERM);
        usleep(100000);
        break;
      case 2:
        std::cout << "parfarm: Worker still running. Sending kill signal.\n";
        kill(pid, SIGKILL);
        usleep(200000);
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
  // Fclear();

  // Let's accept commands
  Worker::loop();

  // Clean up: close pipes and quit local octave
#if PARFARM_VERBOSE
  std::cout << "Worker cleaning up\n";
#endif
  clean_up_and_exit(0, true);
}

void Worker::loop() {
  std::string fn = "x";
  std::string name;
  std::string doc;
  bool glb;
  while (src.good() && res.good()) {
#if PARFARM_VERBOSE
    std::cout << "Worker ready\n";
#endif
    settime0();
    octave_value buf;
    name = read_binary_data(src, false,
                            oct_mach_info::flt_fmt_ieee_little_endian,
                            fn, glb,
                            buf, doc);
    reporttime("Got start of command");
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
    reporttime("got command");
#if PARFARM_VERBOSE
    if (foo.is_string())
      std::cout << "Will evaluate '" << foo.string_value() << "'\n";
    else
      std::cout << "Will evaluate function handle\n";
#endif
    octave_value_list ovl = foo.is_string()
      ? feval(foo.string_value(), args, nargout)
      : (foo.is_inline_function() || foo.is_function_handle())
      ? feval(foo.function_value(), args, nargout)
      : octave_value_list();
    reporttime("calculated");
    bool ok = !error_state && ovl.length()==nargout;
    error_state = 0; // needed?

    dim_vector dvx(1,1);
    int32NDArray x(dvx);
    x(0,0) = ok ? nargout : -1;
    octave_value ov(x);
    reporttime("will second response"); 
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
    reporttime("response sent"); 
    res.flush();
    reporttime("flushed");
  }
}

static void killfarms(std::vector<FarmOut *> &farmout) {
#if PARFARM_VERBOSE
  std::cout << "parfarm: Deleting farmouts.\n";
#endif
  for (std::vector<FarmOut *>::iterator it=farmout.begin();
       it!=farmout.end(); it++)
    delete *it;
  farmout.clear();
#if PARFARM_VERBOSE
  std::cout << "parfarm: Farmouts deleted.\n";
#endif
}

static void killerror(std::vector<FarmOut *> &farmout, char const *msg) {
#if PARFARM_VERBOSE
  std::cout << "parfarm: " << msg << "\n";
#endif
  killfarms(farmout);
  error(msg);
}

DEFUN_DLD (parfarm, args, nargout,
           "PARFARM - Parallel processing farm\n"
           "   res = PARFARM(foo, arg), where FOO is a function name or handle,\n"
           "   and ARG is a cell array, is equivalent to:\n"
           "     for k=1:numel(arg)\n"
           "        res{k} = feval(foo, arg{k});\n"
           "     end\n"
           "   However, PARFARM is much faster on a multi-core or multi-CPU computer,\n"
           "   because the function calls are performed in parallel.\n\n"
           "   [res1, res2, ...] = PARFARM(foo, arg1, arg2, ...) is also supported.\n"
           "   In this case, ARG2, ... may be cell arrays with the same number of\n"
           "   elements as ARG1, or they may be other kinds of objects that will\n"
           "   be passed to FOO without indexing.\n\n"
           "   The number of input arguments and the number of output arguments\n"
           "   are completely independent from each other. RES1, RES2, ... will\n"
           "   always be cell vectors.\n\n"
           "   PARFARM(n) sets the number of sub-processes to use. Currently, N is\n"
           "   arbitrarily restricted between 2 and 8.\n\n"
           "   PARFARM() kills the subprocesses. They will be automatically restarted\n"
           "   at the next call to PARFARM.\n\n"
           "   It is typically best to initialize PARFARM before loading too much\n"
           "   data, because that results in faster initial forking. (But it does\n"
           "   not affect overall performance.)\n\n"
           "   If any of the calls fail, the corresponding cells in the outputs are\n"
           "   set to [], and a warning is printed. In the future, an option to\n"
           "   generate an error message will be implemented.\n\n"
           "   Caution: Under certain circumstances, PARFARM can be slower than a\n"
           "   direct loop. This happens especially if the calculations are very fast\n"
           "   and involve a large amount of data. The reason is that data into and out\n"
           "   of PARFARM have to be transported between processes using Posix IPC.\n") {
  static std::vector<FarmOut *> farmout;
  static int farmcount = 2;
  int nout = nargout>0 ? nargout : 1;

  settime0();

  dim_vector dv(1, nout);
  octave_value_list out(dv);
  
  if (args.length()==0) {
    killfarms(farmout);
    return out;
  }

  if (farmout.empty() || args.length()==1) {
    killfarms(farmout);
    if (args.length()==1) {
      int32NDArray x = args(0).int32_array_value();
      if (error_state)
        error("Bad arguments");
      farmcount = x(0, 0);
      if (farmcount<2 || farmcount>8) {
        error("parfarm will only work with 2 to 8 processes");
        return out; // not executed
      }
    }
    try {
      for (int k=0; k<farmcount; k++)
        farmout.push_back(new FarmOut);
    } catch (std::exception) {
      std::cout << "parfarm: Failed to start farmout\n";
      for (std::vector<FarmOut *>::iterator it=farmout.begin();
           it!=farmout.end(); it++)
        delete *it;
      farmout.clear();
      error("parfarm: failed to start farmout");
      return out;
    }
    if (args.length()==1)
      return out;
  }
  
  if (args.length()<2) {
    error("parfarm: need function name and arguments");
    return out;
  }

  // construct argument count
  dim_vector dvx(1,2);
  int32NDArray x(dvx);
  x(0,0) = args.length()-1;
  x(0,1) = nout;
  octave_value argcnt = x;

  int nelem = args(1).numel();
  std::vector<Cell> cells;
  for (int k=0; k<nout; k++)
    cells.push_back(Cell(nelem, 1));
  
  std::vector<int> state(nelem); // 0: ready to go; 1: working; 2: done.
  std::vector<bool> busy(farmout.size());
  std::vector<int> current(farmout.size()); // ielem in progress per farm
  for (int k=0; k<farmout.size(); k++)
    current[k] = -1;
  int ndone = 0;
  int nbusy = 0;
  reporttime("Ready to start farming");
  while (ndone<nelem) {
    int ifarm = -1;
    int ielem = -1;
    if (nbusy<farmout.size()) {
      // find a worker
      for (int i=0; i<farmout.size(); i++) {
        if (!busy[i]) {
          ifarm = i;
          break;
        }
      }
      if (ifarm<0) {
        killerror(farmout, "Internal error: No worker");
        return out;
      }

      // find something to do
      for (int i=0; i<nelem; i++) {
        if (state[i]==0) {
          ielem = i;
          break;
        }
      }
    }

    if (ielem>=0) {
      // something to do
      std::cout << "Setting worker #" << ifarm+1
                << " to work on element #" << ielem+1
                << "/" << nelem
                << "...   \n";
      reporttime("Sending command");
      std::cout.flush();
      state[ielem] = 1;
      busy[ifarm] = true;
      current[ifarm] = ielem;
      nbusy ++;
      
      if (!farmout[ifarm]->sendOValue(argcnt)) {
        killerror(farmout, "failed to send count");
        return out;
      }
      for (int k=0; k<args.length(); k++) {
        if (args(k).is_cell()) {
          Cell c = args(k).cell_value();
          if (c.numel()==nelem) {
            octave_value ov = c(ielem);
            if (!farmout[ifarm]->sendOValue(ov)) {
              killerror(farmout, "failed to send data");
              return out;
            }
          } else {
            if (!farmout[ifarm]->sendOValue(args(k))) {
              killerror(farmout, "failed to send data");
              return out;
            }
          }
        } else {
          if (!farmout[ifarm]->sendOValue(args(k))) {
            killerror(farmout, "failed to send data");
            return out;
          }
        }
      }
      farmout[ifarm]->toWorker().flush();
      reporttime("Done sending command");
    } else {
      // nothing more to start or all farms working
      int maxfd = -1; 
      for (int k=0; k<farmout.size(); k++) {
        int recfd = farmout[k]->fdFromWorker();
          if (recfd>maxfd)
            maxfd = recfd;
      }
      fd_set rfd, wfd, efd;
      struct timeval to;
#if PARFARM_VERBOSE
      std::cout << "Waiting for results\n";
#endif
      while (true) {
        FD_ZERO(&rfd);
        FD_ZERO(&wfd);
        FD_ZERO(&efd);
        for (int k=0; k<farmout.size(); k++) {
          int recfd = farmout[k]->fdFromWorker();
          FD_SET(recfd, &rfd);
          FD_SET(recfd, &efd);
        }
        to.tv_sec = 1;
        to.tv_usec = 0;
        int r = select(maxfd+1, &rfd, &wfd, &efd, &to);
        if (r<0) {
          perror("select failed");
          killerror(farmout, "select failed");
        }
        if (octave_signal_caught) {
          std::cout << "Ctrl-C received\n";
          killfarms(farmout);
          octave_signal_caught = 0;
          octave_handle_signal();
          return out;
        }
        if (r==0) {
#if PARFARM_VERBOSE
          std::cout << "(still waiting)\n";
#endif
          continue;
        }
        int ifarm = -1;
        for (int k=0; k<farmout.size(); k++) {
          int recfd = farmout[k]->fdFromWorker();
          if (FD_ISSET(recfd, &efd)) {
            killerror(farmout, "Exception from select");
            return out;
          }
          if (FD_ISSET(recfd, &rfd)) {
            ifarm = k;
            break;
          }
        }
        if (ifarm<0) {
          killerror(farmout, "Crazy results from select");
          return out;
        }
        // Worker ifarm is done!
        int ielem = current[ifarm];
        if (ielem<0) {
          killerror(farmout, "Crazy ielem");
          return out;
        }
 	std::cout << "Farm " << ifarm << " done with " << ielem << "\n";
        reporttime("Receiving results");
        state[ielem] = 2; // done
        ndone++;
        nbusy--;
        busy[ifarm] = false;
        current[ifarm] = -1;
        octave_value aocnt;
        r = farmout[ifarm]->receiveOValue(aocnt);
        if (!r) {
          killerror(farmout, "failed to receive count");
          return out;
        }
        x = aocnt.int32_array_value();
        int n = x(0,0);
        
        if (n<0) {
          std::cout << "Warning: Element #" << ielem+1
                    << " did not generate a valid result.\n\n";
        } else {
          if (n>nout)
            n = nout;
          for (int k=0; k<n; k++) {
            octave_value v;
            r = farmout[ifarm]->receiveOValue(v);
            cells[k](ielem) = v;
            if (!r) {
              killerror(farmout, "failed to receive results");
              return out;
            }
          }
        }
        reporttime("Done receiving");
        break;
      }     
    }
  }
  /* We will have nelem processes to run; let's get ready for results */
  std::cout << "All done.                                                 \n";
  reporttime("Creating output");
  for (int k=0; k<nout; k++) 
    out(k) = octave_value(cells[k]);
   reporttime("Returning from call");
  return out;
}

