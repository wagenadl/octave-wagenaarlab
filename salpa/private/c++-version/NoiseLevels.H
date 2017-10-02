/* common/NoiseLevels.H: part of meabench, an MEA recording and analysis tool
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

// NoiseLevels.H

#ifndef NOISELEVELS_H

#define NOISELEVELS_H

#include <common/MedianVariance.H>
#include <common/ChannelNrs.H>
#include <base/Error.H>
#include <fstream>
#include <math.h>

#define NL_SUFFIX ".noise"

class NoiseLevels {
public:
  static const int MINCHUNKS=5;
public:
  NoiseLevels() { reset(); }
  float mean(int hw) const { return means[hw]; }
  float var(int hw) const { return vars[hw]; }
  float std(int hw) const { return stds[hw]; }
  float operator[](int hw) const { return stds[hw]; }
  void load(string const &fnb) throw(Error) {
    string fn(fnb); fn+=NL_SUFFIX;
    ifstream file(fn.c_str());
    if (!file) throw SysErr("NoiseLevels","Cannot load");
    for (int hw=0; hw<TOTALCHANS; hw++) {
      int cr;
      file >> cr;
      if (cr12hw(cr) != hw)
	throw Error("NoiseLevels","Out of sequence");
      file >> means[hw];
      file >> vars[hw];
      stds[hw]=sqrt(vars[hw]);
    }
    ready=true;
  }
  void save(string const &fnb) throw(Error) {
    if (!ready)
      makeready();
    string fn(fnb); fn+=NL_SUFFIX;
    ofstream file(fn.c_str());
    if (!file) throw SysErr("NoiseLevels","Cannot save");
    for (int hw=0; hw<TOTALCHANS; hw++) {
      int c,r; hw2cr(hw,c,r);
      int cr = 10*c+r+11;
      file << cr; file << " ";
      file << means[hw]; file << " ";
      file << vars[hw]; file << "\n";
    }
  }
  void reset() {
    for (int hw=0; hw<TOTALCHANS; hw++) 
      mv[hw].reset();
    ready=false;
  }
  void setnotready() {
    ready=false;
  }
  void train(Sample const *src, int n) {
    for (int i=0; i<n; i++)
      for (int hw=0; hw<TOTALCHANS; hw++)
	mv[hw].addexample(src[i][hw]);
  }
  void makeready() throw(Error) {
    if (chunks() < MINCHUNKS)
      throw Error("NoiseLevels","Too few chunks to compute meaningful estimates");
    for (int hw=0; hw<TOTALCHANS; hw++) {
      means[hw]=mv[hw].mean();
      vars[hw]=mv[hw].var();
      stds[hw]=sqrt(vars[hw]);
    }
    ready=true;
  }
  void force(int hw, double mean, double var) {
    means[hw]=mean; vars[hw]=var; stds[hw]=sqrt(var);
    ready=true;
  }
  int chunks() const { return mv[0].chunks(); }
  void cleanout() {
    for (int hw=0; hw<TOTALCHANS; hw++)
      mv[hw].reset();
  }
  bool isready() const { return ready; }

  void report() {
    report("Means",means);
    report("RMS",stds);
    fprintf(stderr,"All values are digital units.\n");
  }
  void report(char const *label, float *data) {
    fprintf(stderr,"%s:\n",label);
    fprintf(stderr,"%4s","");
    for (int col=0; col<8; col++)
      fprintf(stderr,"%8i",col+1);
    fprintf(stderr,"\n");
    
    for (int row=0; row<8; row++) {
      fprintf(stderr,"%4i",row+1);
      for (int col=0; col<8; col++) {
	int hw = cr2hw(col,row);
	string r = Sprintf("%.1f",data[hw]);
	if (r.size()>7)
	  r = r.substr(0,7);
	fprintf(stderr,"%8s",r.c_str());
      }
      fprintf(stderr,"\n");
    }
  }

private:
  MedianVariance<double> mv[TOTALCHANS];
  float means[TOTALCHANS];
  float vars[TOTALCHANS];
  float stds[TOTALCHANS];
  bool ready;
};

#endif
