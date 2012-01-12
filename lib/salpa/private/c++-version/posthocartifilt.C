/* artifilt/posthocartifilt.C: part of meabench, an MEA recording and analysis tool
** Copyright (C) 2000-2002  Daniel Wagenaar (wagenaar@caltech.edu)
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

// posthocartifilt.C

#include <common/Types.H>
#include <common/Config.H>

#include "LocalFit.H"
#include <common/NoiseLevels.H>

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

const int BLOCKSIZE=2048;
const timeref_t BLOCKMASK=2047;
const int LOG2BLOCKSIZE4=13; // 13 = log_2(8192)

void usage() {
  fprintf(stderr,
	  "Usage: solosalpa -t threshold_digi -x threshold_std -n noisefilename\n"
	  "                 -l halflength_ms -a asymtime_ms -b blanktime_ms\n"
	  "                 -A Ahead_ms -rrail1_digi[,rail2_digi]\n"
	  "                 -p period_ms -d delay_ms -f forcepeg_ms\n"
	  "\n"
	  "Performs post-hoc artifact filtering using LocalFit.\n"
	  "-t and -x are mutually exclusive.\n"
	  "-n can be used to read a previously recorded noise estimate from disk iff\n"
	  "   -x is used. If -x is given without -n, artifilt will estimate the noise\n"
	  "   anew, based on the first 2 s of the recording, using NoiseLevels.\n"
	  "-l specifies the half-width of the fit window.\n"
	  "-a specifies the size of the beginning of the fit window used for initial\n"
	  "   goodness-of-fit estimation.\n"
	  "-b specifies how much of the first fit is blanked.\n"
	  "-A specifies how many samples ahead a peg is detected.\n"
	  "-r specifies one or two digital values that are treated as rails.\n"
	  "-p, -d, -f can be used to force a peg response if the electrode recording\n"
	  "   does not really hit the rail. Pegs of length f are enforced at t=k*p+d.\n"
	  "\n"
	  "Default values are: l=3ms, a=0.2ms, b=0.4ms, A=0.2ms, x=3, r=0,4095, and no\n"
	  "forced peg response.\n");
  exit(1);
}

int main(int argc, char **argv) {
  int thresh_digi=0;
  float thresh_std=3;
  char *noisefn=0;
  int length_sams=FREQKHZ*3;
  int asym_sams = 10;
  int blank_sams = 20;
  int ahead_sams = 5;
  raw_t rail1_digi=0;
  raw_t rail2_digi=4095;
  int period_sams=0; // meaning: don't use
  int delay_sams=0;
  int forcepeg_sams=0;
  char c;
  while ((c=getopt(argc,argv,"t:x:n:l:a:b:A:r:p:d:f:"))!=-1) {
    switch (c) {
    case 't': thresh_digi=atoi(optarg); thresh_std=0; break;
    case 'x': thresh_std=atof(optarg); thresh_digi=0; break;
    case 'n': noisefn=optarg; break;
    case 'l': length_sams=int(FREQKHZ*atof(optarg)); break;
    case 'a': asym_sams=int(FREQKHZ*atof(optarg)); break;
    case 'b': blank_sams=int(FREQKHZ*atof(optarg)); break;
    case 'A': ahead_sams=int(FREQKHZ*atof(optarg)); break;
    case 'r': { rail1_digi=atoi(optarg); char *x=strchr(optarg,','); rail2_digi=x?atoi(x+1):rail1_digi; } break;
    case 'p': period_sams=int(FREQKHZ*atof(optarg)); break;
    case 'd': delay_sams=int(FREQKHZ*atof(optarg)); break;
    case 'f': forcepeg_sams=int(FREQKHZ*atof(optarg)); break;
    default: usage();
    }
  }

  if (thresh_digi!=0 && (thresh_std!=0 || noisefn!=0))
    usage();
  if (optind<argc)
    usage();


  FILE *in = stdin; //fopen("/data/dw/orlando-010812/post13-21-1.raw.60hz.raw","rb");
  FILE *out= stdout; //fopen("/home/wagenaar/tmp/paf.raw","wb");



  int fragsams=4*BLOCKSIZE;
  if (thresh_std!=0 && noisefn==0) 
    fragsams=FREQKHZ*2000;
  int log2fragsams=int(ceil(log(fragsams+0.)/log(2.)));
  fragsams=1<<log2fragsams;
  try {
    CyclBuf<Sample> source(log2fragsams);
    CyclBuf<Sample> dest(LOG2BLOCKSIZE4);
    timeref_t filledto = 0;
    timeref_t basesubto = 0;
    timeref_t processedto = 0;
    timeref_t savedto = 0;
    timeref_t nextpeg = delay_sams ? delay_sams : INFTY;
    float thresh[NCHANS];
    
    Sample basesub; basesub.settoint(0); basesub.setelctoint(-2048);
    
    if (thresh_std!=0) {
      NoiseLevels noise;
      if (noisefn) {
	noise.load(noisefn);
      } else {
	// go get noise estimate
	int n=fread(&source[0],sizeof(Sample),fragsams,in);
	if (n!=fragsams)
	  throw SysErr("posthocartifilt","Cannot read enough data for noise estimte");
	filledto = n;
	noise.train(&source[0],n);
	noise.makeready();
      }
      for (int hw=0; hw<NCHANS; hw++) {
	thresh[hw] = noise[hw]*thresh_std;
	basesub[hw]= (raw_t)(-noise.mean(hw));
      }
      
    } else {
      for (int hw=0; hw<NCHANS; hw++)
	thresh[hw] = thresh_digi;
    }

//    for (int hw=0; hw<NCHANS; hw++)
//	fprintf(stderr, "hw=%2i thresh=%5.1f\n",hw,thresh[hw]);

    LocalFit *fitters[NCHANS];
    LF_Source *sources[NCHANS];
    LF_Dest *dests[NCHANS];
    for (int hw=0; hw<NCHANS; hw++) {
      sources[hw] = new LF_Source(hw,source);
      dests[hw] = new LF_Dest(hw,dest);
      fitters[hw] = new LocalFit(*sources[hw],*dests[hw], 0,
				 int(thresh[hw]), length_sams,
				 blank_sams, ahead_sams, asym_sams);
      fitters[hw]->setrail(rail1_digi+basesub[hw],rail2_digi+basesub[hw]);
    }

    bool at_eof=false;
    bool go_on=true;
    while (go_on) {
      go_on=false;

      // -- save some stuff
      timeref_t mightsaveto = processedto & ~BLOCKMASK;
      while (savedto<mightsaveto) {
	go_on=true;
	fwrite(&dest[savedto],sizeof(Sample),BLOCKSIZE,out);
	savedto+=BLOCKSIZE;
      }

      // -- subtract baseline
      while (basesubto < filledto) {
	source[basesubto++]+=basesub;
//	  Sample &s(source[basesubto++]);
//	  for (int j=0; j<NCHANS; j++)
//	    s[j]-=basesub;
      }

      // -- subtract artifacts
      timeref_t mightprocessto = filledto - forcepeg_sams - 3*length_sams -2;
      if (mightprocessto > savedto + 4*BLOCKSIZE)
	mightprocessto = savedto + 4*BLOCKSIZE;
      while (processedto < mightprocessto) {
	go_on=true;
	if (nextpeg < mightprocessto) {
	  for (timeref_t tt=processedto; tt<nextpeg+forcepeg_sams; tt++)
	    for (int hw=NCHANS; hw<TOTALCHANS; hw++)
	      dest[tt][hw]=source[tt][hw];
	  //	  fprintf(stderr,"Forcepeg: %.5f %.5f\n",nextpeg/25000.,(nextpeg+forcepeg_sams)/25000.);
	  for (int hw=0; hw<NCHANS; hw++) 
	    if (fitters[hw]->forcepeg(nextpeg,nextpeg+forcepeg_sams) != nextpeg+forcepeg_sams)
	      throw Error("posthocartifilt",
			  "LocalFit doesn't like my data (while pegging)!");
	  processedto=nextpeg+forcepeg_sams;
	  nextpeg += period_sams;
	} else {
	  for (timeref_t tt=processedto; tt<mightprocessto; tt++)
	    for (int hw=NCHANS; hw<TOTALCHANS; hw++)
	      dest[tt][hw]=source[tt][hw];
	  for (int hw=0; hw<NCHANS; hw++)
	    if (fitters[hw]->process(mightprocessto) != mightprocessto)
	      throw Error("posthocartifilt", "LocalFit doesn't like my data!");
	  processedto=mightprocessto;
	}
      }

      // -- read input
      if (!at_eof) {
	int n=fread(&source[filledto],sizeof(Sample),BLOCKSIZE,in);
	if (n<0) 
	  throw SysErr("posthocartifilt","Cannot read from input");
	filledto+=n;
	if (n>0)
	  go_on=true;
	if (n!=BLOCKSIZE)
	  at_eof=true;
      }
    }


    // -- EOF!
    
    // let's process the last bit...
    timeref_t mightprocessto = filledto - 2*length_sams-1;
    for (timeref_t tt=processedto; tt<mightprocessto; tt++)
      for (int hw=NCHANS; hw<TOTALCHANS; hw++)
	dest[tt][hw]=source[tt][hw];
    for (int hw=0; hw<NCHANS; hw++) 
      if (fitters[hw]->process(mightprocessto) != mightprocessto)
	throw Error("posthocartifilt", "LocalFit doesn't like my data!");

    // let's save last bit
    for (timeref_t t=savedto; t<processedto; t++)
      fwrite(&dest[t],sizeof(Sample),1,out);

    
    return 0;
  } catch (Error const &e) {
    e.report();
    exit(3);
  }
}
