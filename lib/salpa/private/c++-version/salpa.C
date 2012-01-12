/* artifilt/salpa.C: part of meabench, an MEA recording and analysis tool
** Copyright (C) 2000-2003  Daniel Wagenaar (wagenaar@caltech.edu)
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

// salpa.C

#include <common/MEAB.H>
#include "StreamLF.H"
#include "Defs.H"
#include "EventReporter.H"
#include <common/directory.H>
#include <base/minmax.H>

#include <math.h>

const int TRAINLENGTH = FREQKHZ*5000;
const int BLOCKSIZE=2048;
const timeref_t BLOCKMASK=2047;
const int LOG2BLOCKSIZE4=13; // 13 = log_2(8192)
const int BLOCKSHIFT=2048;
const int BUFUSEIVAL = FREQKHZ * 1000 / 2;

LocalFit *fitters[NCHANS];
LF_Source *sources[NCHANS];
LF_Dest *dests[NCHANS];
EventReporter *reporters[NCHANS];
EventOut *eventout;

int thresh_digi=0;
float thresh_std=3;
double thresh[NCHANS];
raw_t basesub[TOTALCHANS];
int length_sams=75;
int asym_sams = 10;
int blank_sams=20;
int ahead_sams=5;
int period_sams=0;
int delay_sams=0;
int forcepeg_sams=0;

raw_t rail1_digi=0;
raw_t rail2_digi=4095;
bool trigpeg = false;
int trigpeg_hw = 60;
int trigpeg_thresh = rail2_digi;
bool onlysome = false;
bool channelmap[NCHANS];
bool useevents = true;

void init() {
  for (int hw=0; hw<NCHANS; hw++) {
    fitters[hw]=0;
    sources[hw]=0;
    dests[hw]=0;
    channelmap[hw] = true;
    reporters[hw]=0;
  }
}

void set_some(int argc=0, char **args=0) {
  if (argc) {
    bool minus = strcmp(args[0],"-")==0;
    bool plus = strcmp(args[0],"+")==0;

    if (argc==1 && minus) {
      onlysome = false;
    } else if (argc==1 && plus) {
      onlysome = true;
    } else {
      onlysome = true;
      if (!minus && !plus)
	for (int c=0; c<NCHANS; c++)
	  channelmap[c] = false;
      for (int argi=(minus||plus)?1:0; argi<argc; argi++) {
	int hw = cr12hw(atoi(args[argi]));
	if (hw<0 || hw>=NCHANS)
	  throw Error("somechannels","Bad channel list");
	channelmap[hw] = minus ? false : true;
      }
    }
  }
  if (onlysome) {
    fprintf(stderr,"Operating only on the following channels:\n ");
    for (int c=0; c<NCHANS; c++)
      if (channelmap[c])
	fprintf(stderr," %s",hw2string(c).c_str());
    fprintf(stderr,"\n");
  } else {
    fprintf(stderr,"Operating on all channels\n");
  }
}

string getsome() {
  if (onlysome) {
    string r="";
    for (int c=0; c<NCHANS; c++) {
      if (channelmap[c]) {
	r += " ";
	r += hw2string(c);
      }
    }
    return r;
  } else {
    return "All";
  }
}

void set_useevents(int argc=0, char **args=0) {
  if (argc) {
    useevents = atoi(args[0])>0;
  }
  if (useevents)
    fprintf(stderr,"Event stream enabled\n");
  else
    fprintf(stderr,"Event stream disabled\n");
}

void set_trigpeg(int argc=0, char **args=0) {
  if (argc) {
    if (argc==1 && strcmp(args[0],"-")==0) {
      trigpeg = false;
    } else {
      trigpeg = true;
      delay_sams = 0; // disable fixedperiod
      int hw = string2hw(args[0]);
      if (hw<NCHANS) 
	throw Error("trigpeg","Bad trigger channel");
      trigpeg_hw = hw;
      if (argc>1)
	forcepeg_sams = int(FREQKHZ * atof(args[1]));
      if (argc>2)
	trigpeg_thresh = atoi(args[2]);
    }
  }
  if (trigpeg)
    fprintf(stderr,"Pegging on trigger on %s. Blank: %.2f ms Thresh: %i.\n",
	    hw2string(trigpeg_hw).c_str(),
	    double(forcepeg_sams)/FREQKHZ,
	    trigpeg_thresh);
  else
    fprintf(stderr,"Not pegging on An triggers\n");
}
    

string summary() {
  float freqhz = MEAB::rawin->sfcli.aux()->sourceinfo.freqhz;
  if (freqhz==0)
    freqhz = 1000*FREQKHZ;
  float freqkhz = freqhz/1000;
  string thresh = thresh_digi
    ? Sprintf("digithr:%i",thresh_digi)
    : Sprintf("noisethr:%.1f",thresh_std);
  string period = period_sams
    ? Sprintf("fix:%.2f,%.2f,%.2f",
	      period_sams/freqkhz,
	      delay_sams/freqkhz,
	      forcepeg_sams/freqkhz)
    : "";
  string trigp = trigpeg
    ? Sprintf("peg:%s,%.2f,%i",
	      hw2string(trigpeg_hw).c_str(),
	      forcepeg_sams/freqkhz,
	      trigpeg_thresh)
    : "";
	    
  return Sprintf("halfw:%.2f asym:%.2f blank:%.2f lookahead:%.2f %s %s %s",
		 length_sams/freqkhz,
		 asym_sams/freqkhz,
		 blank_sams/freqkhz,
		 ahead_sams/freqkhz,
		 thresh.c_str(),
		 period.c_str(),
		 trigp.c_str());
}

void getthreshs() {
  if (thresh_digi)
    for (int hw=0; hw<NCHANS; hw++)
      thresh[hw]=thresh_digi;
  else if (MEAB::noise.isready())
    for (int hw=0; hw<NCHANS; hw++)
      thresh[hw]=thresh_std * MEAB::noise[hw];
  else
    throw Error("thresholds","Noise levels unknown");
}

void getbases() {
   if (MEAB::noise.isready())
     for (int hw=0; hw<NCHANS; hw++)
       basesub[hw]=raw_t(MEAB::noise.mean(hw));
   else 
     for (int hw=0; hw<NCHANS; hw++)
       basesub[hw]=MEAB::rawin->sfcli.aux()->sourceinfo.digizero;

   for (int hw=NCHANS; hw<TOTALCHANS; hw++)
     basesub[hw]=0;
}

void ensurefilt() {
  getthreshs();
  for (int hw=0; hw<NCHANS; hw++) {
    if (!sources[hw])
      sources[hw]=new LF_Source(hw,MEAB::rawout->sfsrv, BLOCKSHIFT);
    if (!dests[hw])
      dests[hw]=new LF_Dest(hw,MEAB::rawout->sfsrv);
    if (!fitters[hw]) 
      fitters[hw]=new LocalFit(*sources[hw],*dests[hw], 0,
			       int(thresh[hw]), length_sams,
			       blank_sams, ahead_sams, asym_sams);
    if (eventout && useevents) {
      if (!reporters[hw])
	reporters[hw] = new EventReporter(&eventout->sfsrv, hw);
      fitters[hw]->enableEvents(reporters[hw]);
    }
  }
}

void autorail() {
  getbases();
  for (int hw=0; hw<NCHANS; hw++) {
    fitters[hw]->setrail(MEAB::rawin->sfcli.aux()->sourceinfo.digimin-basesub[hw],
			 MEAB::rawin->sfcli.aux()->sourceinfo.digimax-basesub[hw]);
//    sdbx("ef: hw=%2i base=%5i min=%i max=%i 578=%i",hw,basesub[hw],
//	 MEAB::rawin->sfcli.aux()->sourceinfo.digimin,
//	 MEAB::rawin->sfcli.aux()->sourceinfo.digimax, 578);
  }
}

void delfilt() {
  for (int hw=0; hw<NCHANS; hw++) {
    if (fitters[hw])
      delete fitters[hw];
    fitters[hw]=0;
    if (dests[hw])
      delete dests[hw];
    dests[hw]=0;
    if (sources[hw])
      delete sources[hw];
    sources[hw]=0;
    if (reporters[hw])
      delete reporters[hw];
    reporters[hw]=0;
  }
}

void set_thresh_digi(int argc=0, char **args=0) {
  if (argc) {
    thresh_std=0;
    thresh_digi = atoi(args[0]);
    delfilt();
  }
  if (thresh_digi) 
    fprintf(stderr,"Threshold is %i digital units\n",thresh_digi);
  else
    fprintf(stderr,"Threshold is %.2f std devs\n",thresh_std);
}

void set_thresh_std(int argc=0, char **args=0) {
  if (argc) {
    thresh_digi=0;
    thresh_std = atof(args[0]);
  }
  if (thresh_digi) 
    fprintf(stderr,"Threshold is %i digital units\n",thresh_digi);
  else
    fprintf(stderr,"Threshold is %.2f std devs\n",thresh_std);
}

void set_length(int argc=0, char **args=0) {
  if (argc) {
    length_sams = int(FREQKHZ*atof(args[0]));
  }
  fprintf(stderr,"Filter half length: %.2f ms\n",1.*length_sams/FREQKHZ);
}

void set_asym(int argc=0, char **args=0) {
  if (argc) {
    asym_sams = int(FREQKHZ*atof(args[0]));
  }
  fprintf(stderr,"Asymmetry test: %.2f ms\n",1.*asym_sams/FREQKHZ);
}

void set_blank(int argc=0, char **args=0) {
  if (argc) {
    blank_sams = int(FREQKHZ*atof(args[0]));
  }
  fprintf(stderr,"Post asymmetry blanking: %.2f ms\n",1.*blank_sams/FREQKHZ);
}

void set_ahead(int argc=0, char **args=0) {
  if (argc) {
    ahead_sams = int(FREQKHZ*atof(args[0]));
  }
  fprintf(stderr,"Look ahead for pegging: %.2f ms\n",1.*ahead_sams/FREQKHZ);
}

//void set_digirail(int argc=0, char **args=0) {
//  if (argc) {
//    rail1_digi=atoi(args[0]);
//    if (argc>1)
//	rail2_digi=atoi(args[1]);
//    else
//	rail2_digi=rail1_digi;
//  }
//  fprintf(stderr,"Digital rails are %i and %i\n",rail1_digi,rail2_digi);
//}

void set_fixed(int argc=0, char **args=0) {
  if (argc) {
    if (argc<2)
      throw Usage("setfixed [period delay [blank]]");
    period_sams = int(FREQKHZ*atof(args[0]));
    delay_sams = int(FREQKHZ*atof(args[1]));
    if (argc>=3)
      forcepeg_sams = int(FREQKHZ*atof(args[2]));
    else
      forcepeg_sams = int(FREQKHZ*1);
    trigpeg = false; // disable triggered pegging
  }
  if (period_sams)
    fprintf(stderr,"Fixed artifact assumption: period: %.2f ms  pre: %.2f  blank: %.2f\n",
	    1.*period_sams/FREQKHZ, 1.*delay_sams/FREQKHZ, 1.*forcepeg_sams/FREQKHZ);
  else
    fprintf(stderr,"No fixed artifact assumption\n");
}

void am_i_ok(char const *issuer) {
  try {
    if (!thresh_digi && !MEAB::noise.isready())
      throw Error(issuer,"Noise levels unknown - train first");
    MEAB::rawsource();
    MEAB::openraw();
    if (!MEAB::rawin)
      throw Error(issuer,"No source");
    MEAB::rawin->sleeper.report_bufuse(0);
    if (!MEAB::rawout)
      throw Error(issuer,"No destination");
    set_length();
    set_asym();
    set_thresh_digi();
    set_blank();
    set_ahead();
    set_fixed();
    set_trigpeg();
    set_some();
    //    set_digirail();
    ensurefilt();
  } catch (Error const &e) {
    MEAB::closeraw();
    e.report();
    throw PlainErr("Cannot run");
  }
}

void endrun() {
  MEAB::rawin->sleeper.report_nobufuse();
  fprintf(stderr,"Buffer use percentages: %s\n",
	  MEAB::rawin->sfcli.bufuse_deepreport().c_str());
  MEAB::rawout->sfsrv.setbufuse(MEAB::rawin->sfcli);
  MEAB::rawout->sfsrv.aux()->trig.n_latest = MEAB::rawin->sfcli.aux()->trig.n_latest;
  MEAB::rawout->sfsrv.aux()->hwstat = MEAB::rawin->sfcli.aux()->hwstat;
  MEAB::rawout->sfsrv.endrun();
  MEAB::rawout->waker.stop();
  if (useevents) {
    sdbx("endrun: eventout=%p",eventout);
    eventout->sfsrv.setbufuse(MEAB::rawin->sfcli);
    sdbx("  trigs");
    eventout->sfsrv.aux()->trig.n_latest = MEAB::rawin->sfcli.aux()->trig.n_latest;
    sdbx("  hwstat");
    eventout->sfsrv.aux()->hwstat = MEAB::rawin->sfcli.aux()->hwstat;
    sdbx("  eventout->sfsrv.endrun");
    eventout->sfsrv.endrun();
    sdbx("  eventout->waker.stop");
    eventout->waker.stop();
    sdbx("  eventout ok");
  }
  MEAB::closeraw();
}

bool startrun() { // return true if source CanSlow
#ifdef MEA_ULTRAFAST
  MEAB::rawin->sleeper.setival(FREQKHZ*5);
#else
  MEAB::rawin->sleeper.setival(FREQKHZ*10);
#endif
  MEAB::rawin->sleeper.report_yesbufuse();
  MEAB::rawin->sfcli.bufuse_reset();
  bool canslow = MEAB::rawin->wait4start();
  if (canslow) {
    MEAB::rawout->waker.send(Wakeup::CanSlow);
    fprintf(stderr,"Automatic source slow-down supported\n");
  } else {
    MEAB::rawin->sleeper.report_nobufuse();
  }
  autorail();
  MEAB::rawout->sfsrv.startrun();
  *MEAB::rawout->sfsrv.aux() = *MEAB::rawin->sfcli.aux();
  MEAB::rawout->sfsrv.aux()->addpar("Salpa",summary());
  MEAB::rawout->sfsrv.aux()->addpar("Salpa channels",getsome());
  raw_t halfrange = MEAB::rawout->sfsrv.aux()->sourceinfo.nominalrange;
  MEAB::rawout->sfsrv.aux()->sourceinfo.digizero = 0;
  MEAB::rawout->sfsrv.aux()->sourceinfo.digimin = -halfrange;
  MEAB::rawout->sfsrv.aux()->sourceinfo.digimax = halfrange-1;

  MEAB::rawout->waker.start(); // send a start command to our clients
  for (int hw=0; hw<NCHANS; hw++)
    fitters[hw]->reset(MEAB::rawout->sfsrv.latest());

  if (useevents) {
    sdbx("salpa: eventout=%p",eventout);
    if (canslow)
      eventout->waker.send(Wakeup::CanSlow);
    eventout->sfsrv.startrun();
    eventout->waker.start();
  }
  
  return canslow;
}  

void dorun() {
  try {
    MEAB::varspeed = startrun();

    timeref_t last = MEAB::rawin->sfcli.first();
    if (MEAB::varspeed)
      MEAB::rawin->sleeper.report_bufuse(last);
    timeref_t processedto = MEAB::rawout->sfsrv.latest();
    timeref_t savedto = MEAB::rawout->sfsrv.latest();
    timeref_t filledto = MEAB::rawout->sfsrv.latest();
    timeref_t nextpeg = delay_sams
      ? (MEAB::rawout->sfsrv.latest()+delay_sams)
      : INFTY;
    timeref_t nextbufuse = last + BUFUSEIVAL;

    sdbx("dorun3");
    timeref_t next=0;
    timeref_t realnext=0;
    while (!Sigint::isset()) {
      timeref_t event0 = eventout->sfsrv.latest();
      int res = (next==realnext)
	? MEAB::rawin->sleeper.block()
	: MEAB::rawin->sleeper.poll();
      dbx(Sprintf("block -> %i",res));
      if (res==Wakeup::Trig)
	MEAB::rawout->sfsrv.aux()->trig = MEAB::rawin->sfcli.aux()->trig;
        // This program ignores triggers entirely, but does pass them on.
      realnext = MEAB::rawin->sfcli.latest();
      next = min(realnext, last+FREQKHZ*50); // process in little chunks
      MEAB::rawin->sfcli.bufuse_update(last);
      
      /* Process data here!
         The job is to take the data in [last,next), subtract the baseline,
         detect and subtract artifacts, and dump the result out.
       * I cannot deal with all of the input data, since I need a buffer
         before and after the processed window.
      */

      // -- subtract baseline, and report buffer use to server
      int i=0;
      //      sdbx("last=%Li processedto=%Li savedto=%Li filledto=%Li nextpeg=%Li",last,processedto,savedto,filledto,nextpeg);
      while (last<next) {
	if (--i<0) {
	  i=10000;
	  if (MEAB::varspeed && last>=nextbufuse) {
	    MEAB::rawin->sleeper.report_bufuse(last);
	    nextbufuse = last + BUFUSEIVAL;
	    sdbx("buffer use: last=%Li next=%Li",last,next);
	  }
	}
	Sample &d(MEAB::rawout->sfsrv[BLOCKSHIFT + filledto++]);
	Sample const &s(MEAB::rawin->sfcli[last++]);
	for (int hw=0; hw<TOTALCHANS; hw++)
	  d[hw]=s[hw]-basesub[hw];
	//	sdbx("filledto=%Li d[59]=%i",filledto,d[59]+0);
      }
      
      // -- subtract artifacts
      timeref_t sub = forcepeg_sams + 3*length_sams + 2 + ahead_sams;
      timeref_t mightprocessto = filledto>sub
	? filledto-sub
	: 0;
      while (processedto < mightprocessto) {
	if (trigpeg) {
	  for (timeref_t tt=processedto+ahead_sams; tt<filledto; tt++) {
	    Sample const &s(MEAB::rawout->sfsrv[BLOCKSHIFT + tt]);
	    if (s[trigpeg_hw]>=trigpeg_thresh) {
	      nextpeg = max(tt-ahead_sams, processedto);
	      sdbx("pegontrig: tt=%Li nextpeg=%Li processedto=%Li (diff=%Li) mightprocessto=%Li",
		   tt,nextpeg,processedto,nextpeg-processedto,mightprocessto);
	      break;
	    }
	  }
	}
	timeref_t doprocessto = mightprocessto;
	bool willpeg = false;
	if (nextpeg < mightprocessto + length_sams) {
	  willpeg = true;
	  doprocessto = nextpeg+forcepeg_sams;
	}
	for (timeref_t tt=processedto; tt<doprocessto; tt++) {
	  Sample const &s(MEAB::rawout->sfsrv[BLOCKSHIFT + tt]);
	  Sample &d(MEAB::rawout->sfsrv[tt]);
	  for (int hw=NCHANS; hw<TOTALCHANS; hw++)
	    d[hw]=s[hw];
	}
	if (onlysome) {
	  if (willpeg) {
	    // some channels, will peg
	    for (timeref_t tt=processedto; tt<nextpeg; tt++) {
	      Sample const &s(MEAB::rawout->sfsrv[BLOCKSHIFT + tt]);
	      Sample &d(MEAB::rawout->sfsrv[tt]);
	      for (int hw=0; hw<NCHANS; hw++)
		d[hw]=s[hw];
	    }
	    for (timeref_t tt=nextpeg; tt<doprocessto; tt++) {
	      Sample &d(MEAB::rawout->sfsrv[tt]);
	      for (int hw=0; hw<NCHANS; hw++)
		d[hw]=0;
	    }
	    for (int hw=0; hw<NCHANS; hw++)
	      if (channelmap[hw])
		if (fitters[hw]->forcepeg(nextpeg,doprocessto)
		  != doprocessto)
		throw Error("salpa",
			    "LocalFit doesn't like my data (while pegging)!");
	    if (trigpeg)
	      nextpeg = INFTY;
	    else
	      nextpeg += period_sams;
	  } else {
	    // some channels, won't peg
	    for (timeref_t tt=processedto; tt<doprocessto; tt++) {
	      Sample const &s(MEAB::rawout->sfsrv[BLOCKSHIFT + tt]);
	      Sample &d(MEAB::rawout->sfsrv[tt]);
	      for (int hw=0; hw<NCHANS; hw++)
		d[hw]=s[hw];
	    }
	    for (int hw=0; hw<NCHANS; hw++)
	      if (channelmap[hw])
		if (fitters[hw]->process(doprocessto)
		    != doprocessto)
		  throw Error("salpa", "LocalFit doesn't like my data!");
	  }
	} else {
	  if (willpeg) {
	    // all channels, will peg
	    for (int hw=0; hw<NCHANS; hw++) 
	      if (fitters[hw]->forcepeg(nextpeg,doprocessto)
		  != doprocessto)
		throw Error("salpa",
			    "LocalFit doesn't like my data (while pegging)!");
	    if (trigpeg)
	      nextpeg = INFTY;
	    else
	      nextpeg += period_sams;
	  } else {
	    // all channels, won't peg
	    for (int hw=0; hw<NCHANS; hw++)
	      if (fitters[hw]->process(doprocessto) != doprocessto)
		throw Error("salpa", "LocalFit doesn't like my data!");
	  }
	}
	processedto=doprocessto;
      }

      // -- publish some stuff
      timeref_t mightsaveto = processedto;
      if (mightsaveto>savedto) {
	MEAB::rawout->wrote(mightsaveto-savedto);
	savedto=mightsaveto;
	MEAB::blockuntil(&MEAB::rawout->waker,savedto>MEAB::BLOCK_THRESH
			                     ? savedto - MEAB::BLOCK_THRESH
			                     : 0);
      }

      if (useevents) {
	timeref_t event1 = eventout->sfsrv.latest();
	eventout->waker.wakeup(event1-event0);
      }
      
      if (res==Wakeup::Stop)
	break;
      else if (res>Wakeup::Poll) 
	MEAB::rawout->waker.send(res);
    }

    // let's process the last bit
    timeref_t mightprocessto = (filledto>2*length_sams-1)
      ? filledto - 2*length_sams-1
      : 0;
    for (timeref_t tt=processedto; tt<mightprocessto; tt++) {
      Sample const &s(MEAB::rawout->sfsrv[BLOCKSHIFT + tt]);
      Sample &d(MEAB::rawout->sfsrv[tt]);
      for (int hw=NCHANS; hw<TOTALCHANS; hw++)
	d[hw]=s[hw];
    }
    if (onlysome) {
      for (timeref_t tt=processedto; tt<mightprocessto; tt++) {
	Sample const &s(MEAB::rawout->sfsrv[BLOCKSHIFT + tt]);
	Sample &d(MEAB::rawout->sfsrv[tt]);
	for (int hw=0; hw<NCHANS; hw++)
	  d[hw]=s[hw];
      }
      for (int hw=0; hw<NCHANS; hw++)
	if (channelmap[hw])
	  if (fitters[hw]->process(mightprocessto)
	      != mightprocessto)
	    throw Error("salpa", "LocalFit doesn't like my data!");
    } else {
      for (int hw=0; hw<NCHANS; hw++) 
	if (fitters[hw]->process(mightprocessto) != mightprocessto)
	  throw Error("salpa", "LocalFit doesn't like my data!");
    }
    processedto=mightprocessto;
    
    // let's save last bit
    timeref_t mightsaveto = processedto;
    if (mightsaveto>savedto) {
      MEAB::rawout->wrote(mightsaveto-savedto);
      savedto=mightsaveto;
    }
    endrun();
  } catch (Error const &e) {
    endrun();
    MEAB::closeraw();
    delfilt();
    throw;
  }
}

void train(int argc, char **args) {
  MEAB::trainnoise(TRAINLENGTH);
}

void run(int argc, char **args) {
  delfilt();
  am_i_ok("run");
  sdbx("run: dest+0 = %p",MEAB::rawout->sfsrv.wheretowrite());
  sdbx("run: sources[0] = %p, %p",sources[0],&(*sources[0])[0]);
  sdbx("run: dests[0] = %p, %p",dests[0],&(*dests[0])[0]);
  dorun();
}

void cont(int argc, char **args) {
  while (1) {
    delfilt();
    am_i_ok("cont");
    dorun();
  }
}

Cmdr::Cmap cmds[] = {
  { Cmdr::quit, "quit", 0,0,""            },
  { cd, "cd", 0, 1, "[directory-name]" },
  { ls, "ls", 0, 100, "[args]" },
  { mkdir, "mkdir", 1, 100, "directory-name" },
  { MEAB::rawsource, "source", 0,1, "[stream-name]" },
  { set_thresh_digi, "digithresh", 0,1, "[digital-threshold]" },
  { set_thresh_std, "noisethresh", 0,1, "[threshold-in-units-of-RMS-noise]" },
  { set_length, "halfwidth", 0,1, "[halfwidth-in-ms]" },
  { set_asym, "asymduration", 0,1, "[asymmetry-window-width-in-ms]" },
  { set_blank, "blankduration", 0,1, "[blanking-duration-in-ms]" },
  { set_ahead, "lookaheadwindow", 0,1, "[look-ahead-window-in-ms]" },
  //  { set_digirail, "digirails", 0,2, "[digi-rail1 [digi-rail2]]" },
  { set_fixed, "fixedperiod", 0,3, "[period-ms delay-ms [blank-ms]]" },
  { set_some, "channels", 0, 60, "[+ | - | CR ...]" },
  { set_trigpeg, "pegontrigger", 0, 3, "[- | An [blank-ms [thresh-digi]]]" },
  { train, "train", 0,0, "" },
  { MEAB::loadnoise, "loadnoise", 1,1, "filename" },
  { MEAB::savenoise, "savenoise", 1,1, "filename" },
  { MEAB::noiseinfo, "info",0,0,""		   },
  { run, "run",0,0,""			   },
  { cont, "cont",0,0,""		   },
  { setdbx, "dbx", 0, 1, "[0/1]" },
  { MEAB::report, "clients", 0, 0, "" },
  {0, "", 0,0, "" }
};

int main(int argc, char **argv) {
  MEAB::progname="salpa";
  MEAB::announce();
  dbx("main");
  init();
  try {
    Sigint si(&delfilt);
    MEAB::makeraw(SALPANAME,LOGRAWFIFOLENGTH);
    eventout = new EventOut(SALPAEVENTNAME, LOGEVENTFIFOLENGTH);
    MEAB::mainloop(argc,argv,cmds,MEAB::rawout->waker,&delfilt);
    return 0;
  } catch (Error const &e) {
    MEAB::mainerror(e,&delfilt);
  } catch (...) {
    fprintf(stderr,"Salpa: Weird exception\n");
    exit(1);
  }
  return 2;
}
