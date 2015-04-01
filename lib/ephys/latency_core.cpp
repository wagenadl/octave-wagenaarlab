// latency_core.cpp

// mex latency_core.cpp

#include "mex.h"
#include <math.h>

static void latency(double const *events, int N,
                    double const *triggers, int K,
                    double *dt) {
  int k = -1;
  double t0 = nan("");
  for (int n=0; n<N; n++) {
    double t = events[n];
    while (k<K-1 && t>=triggers[k+1])
      t0 = triggers[++k];
    dt[n] = t - t0;
  }
}

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]) {
  if (nrhs!=2 || nlhs!=1
      || mxGetClassID(prhs[0])!=mxDOUBLE_CLASS
      || mxGetClassID(prhs[1])!=mxDOUBLE_CLASS
      || mxIsComplex(prhs[0]) || mxIsComplex(prhs[1]))
    mexErrMsgTxt("Inputs must be real vectors");

  plhs[0] = mxCreateNumericMatrix(mxGetM(prhs[0]), mxGetN(prhs[0]),
                                  mxDOUBLE_CLASS, mxREAL);

  double const *events = (double const *)mxGetData(prhs[0]);
  double const *triggers = (double const *)mxGetData(prhs[1]);
  double *dt = (double *)mxGetData(plhs[0]);
  int N = mxGetM(prhs[0])*mxGetN(prhs[0]);
  int K = mxGetM(prhs[1])*mxGetN(prhs[1]);
  latency(events, N, triggers, K, dt);
}
