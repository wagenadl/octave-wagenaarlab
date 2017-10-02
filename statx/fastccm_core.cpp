// fastccm_core.cpp

#include "mex.h"
#include <algorithm>
#include <math.h>
#include <stdio.h>

double ccm(double const *xx, double const *yy, int L, int E,
	   double *dst, double *yhat, int *ord) {
  xx += E;
  yy += E;
  double *dd = dst;
  int *idx = ord;
  ord += E;
  dst += E;
  L -= E;
  for (int t=0; t<L; t++) {
    for (int t1=0; t1<L; t1++) {
      double sd = 0;
      for (int e=0; e<E; e++) {
	double d = xx[t-e] - xx[t1-e];
	sd += d*d;
      }
      dst[t1] = sd;
    }
    
    for (int t=0; t<L; t++)
      ord[t] = t;
    
    for (int e=0; e<E; e++) {
      std::nth_element(ord, ord + e + 1, ord + L,
		       [dst](int lhs, int rhs) { return dst[lhs] < dst[rhs]; });
      idx[e] = ord[e + 1];
      dd[e] = dst[idx[e]];
    }

    double *uu = dd;
    /*
    for (int e=0; e<E; e++) {
      printf(" %g", dd[e]);
    }
    printf("\n");
    */
    for (int e=1; e<E; e++)
      uu[e] = exp(-dd[e] / dd[0]);
    uu[0] = exp(-1.0);

    double su = 0;
    for (int e=0; e<E; e++)
      su += uu[e];

    double yh = 0;
    for (int e=0; e<E; e++)
      yh += uu[e]/su * yy[idx[e]];

    yhat[t] = yh;
  }
  
  // now calculate correlation
  double sy = 0;
  for (int t=0; t<L; t++)
    sy += yy[t];
  double sh = 0;
  for (int t=0; t<L; t++)
    sh += yhat[t];

  // printf("L=%i E=%i sy=%g sh=%g\n", L, E, sy, sh);

  double my = sy/L;
  double mh = sh/L;

  double syy = 0;
  double shh = 0;
  double syh = 0;
  for (int t=0; t<L; t++) {
    double dy = yy[t] - my;
    double dh = yhat[t] - mh;
    syy += dy*dy;
    shh += dh*dh;
    syh += dy*dh;
  }
  double rho = syh / sqrt(syy*shh);
  return rho;
}

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, mxArray const *prhs[]) {
  if (nrhs != 3)
    mexErrMsgTxt("Three inputs required.");
  if (nlhs != 1)
    mexErrMsgTxt("One output required.");

  /* Beyond that, I am going to assume that we are called from FASTCCM,
     so that error checking is not required. */

  double *xx = mxGetPr(prhs[0]);
  double *yy = mxGetPr(prhs[1]);
  int E = int(mxGetScalar(prhs[2]) + .5); // round like matlab does
  int L = mxGetM(prhs[0]) * mxGetN(prhs[0]);

  
  plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
  double *rho = mxGetPr(plhs[0]);

  double *dst = new double[L];
  double *yhat = new double[L];
  int *ord = new int[L];
  *rho = ccm(xx, yy, L, E, dst, yhat, ord);
  delete [] dst;
  delete [] yhat;
  delete [] ord;
}
