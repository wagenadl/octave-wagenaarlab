/* artifilt/LocalFit.H: part of meabench, an MEA recording and analysis tool
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

// LocalFit.H

#ifndef LOCALFIT_H

#define LOCALFIT_H

#include <math.h>

/* Notice: BIG WARNING: For large tau, the sums X3 and X1 become very
   large after multiplication with T4 and T6, especially if the signal
   isn't centered at zero initially. This is problematic from tau>=55 if
   the baseline is as large as 4096, or for tau>=57 if the baseline is 2048.
 * Bottom line: *ALWAYS* remove baseline before passing data in.
 * Perhaps the real solution is to re-do the math with X0 subtracted from
   X1..X3.
*/

#include "Types.h"

class LocalFit {
public:
  enum State { OK, PEGGING, PEGGED, TOOPOOR, DEPEGGING, FORCEPEG, BLANKDEPEG };
  /* State variables kept in each state:

    	 var\state OK PEGGING PEGGED TOOPOOR DEPEGGING FORCEPEG BLANKDEPEG
    		   -- ------- ------ ------- --------- -------- ----------
    	 t_stream   y    y      y      y        y         y         y     
    	 t_0        *    y      *      y        y         +         y     
    	 X_0..2     y    y      n      y        y         n         y     
    	 X_3        n    y      n      y        y         n         y     
    	 alpha_0..3 n    y      n      y        y         n         y     
         toopoorcnt n    n      n      y        n         n         n     
	 
     *: t_0 is implicitly equal to t_stream and not kept
     +: t_0 is used to mark end of forced peg
  */
  static raw_t ZERO;
  static raw_t RAIL1;
  static raw_t RAIL2;
  static int TCHI2; // samples
  static int BLANKDEP; // samples
  static int AHEAD; // samples
  static int TOOPOORCNT;
  typedef double int_t; // was "long long"...
public: 
  LocalFit(raw_t *source, raw_t *dest,
	   timeref_t t_start, timeref_t t_end, raw_t threshold, int tau,
	   int t_blankdepeg=BLANKDEP, int t_ahead=AHEAD,
	   int t_chi2=TCHI2);
  void reset(timeref_t t_start=0);
  void setrail(raw_t r1, raw_t r2) { rail1=r1; rail2=r2; }
  timeref_t process(timeref_t t_limit);
  timeref_t forcepeg(timeref_t t_from, timeref_t t_to);
private:
  void init_T();
  void calc_X012(); // at t0
  void calc_X3(); // at t0
  void update_X0123(); // for t0, from t0-1
  inline void update_X012(); // for t_stream, from t_stream-1 (!)
  void calc_alpha0123(); // from X0123
  inline void calc_alpha0(); // from X02
  State statemachine(timeref_t t_limit, State s);
  bool ispegged(raw_t value) { return value==rail1 || value==rail2; }
private:
  // external world communication
  raw_t *source;
  raw_t *dest;
private:
  // externally imposed constants
  raw_t y_threshold;
  int tau;
  int t_blankdepeg;
  int t_ahead;
  int t_chi2;
  raw_t rail1, rail2;
private:
  // self computed constants
  int_t tau_plus_1;
  int_t tau_plus_1_squared;
  int_t tau_plus_1_cubed;
  int_t minus_tau;
  int_t minus_tau_squared;
  int_t minus_tau_cubed;
  int_t T0, T2, T4, T6;
  real_t my_thresh;
private:
  // state variables
  State state;
  timeref_t t_stream, t0;
  timeref_t t_end;
  real_t X0, X1, X2, X3;
  real_t alpha0, alpha1, alpha2, alpha3;
  int toopoorcnt;
  bool negv;
  timeref_t t_peg;
#if TEST
  timeref_t t_depeg;
  timeref_t t_check;
#endif
public:
  // debug
  void report();
  void inirep();
};

#endif
