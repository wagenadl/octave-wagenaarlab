/* maxima_core.c */

#include "mex.h"

int maxima_core(double *data, int T, double frc, int *idxout) {
  int N=0;
  int t;
  double lastmin=data[0], lastmax=data[0];
  int lastmaxi=0;
  int goingup = data[1]>data[0];
  int maykill = 0;

  for (t=1; t<T; t++) {
    if (goingup) {
      if (data[t]>lastmax && data[t]*frc>=lastmin) {
	lastmax = data[t];
	lastmaxi = t;
      } else if (data[t]<data[t-1]) {
	goingup=0;
      }
    } else {
      /* going down */
      if (lastmaxi>=0) {
	/* have a possible max */
	if (data[t]<=lastmax*frc) {
	  /* validated! */
	  idxout[N++] = lastmaxi;
	  lastmaxi=-1;
	  lastmax=0;
	  lastmin=data[t];
	}
      } else {
	if (data[t]<lastmin)
	  lastmin=data[t];
      }
      if (data[t]>data[t-1]) {
	goingup = 1;
      }
    }
  }
  return N;
}


void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]) {
  double *data;
  double frc; /* relative depth requirement */
  int T; /* length of input data */
  int *peakidx; /* place to build index */
  double *idxout; /* output */
  int n, N;
  mxArray *peakidx_m;
  int peakidx_s[2];

  if (nrhs!=2) 
    mexErrMsgTxt("Two inputs required.");
  if (nlhs!=1) 
    mexErrMsgTxt("One output required.");
  
  /* Check to make sure the first input argument is a vector. */
  if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
      (mxGetN(prhs[0])>1 && mxGetM(prhs[0])>1)) {
    mexErrMsgTxt("Input x must be a vector.");
  }

  /* Check to make sure the second input argument is a scalar. */
  if (!mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) ||
      mxGetN(prhs[1])*mxGetM(prhs[1])!=1) {
    mexErrMsgTxt("Input y must be a scalar.");
  }

  frc = mxGetScalar(prhs[1]);
  
  data = mxGetPr(prhs[0]);
  
  /*  Get the dimensions of the vector input x. */
  T = mxGetM(prhs[0]) * mxGetN(prhs[0]);
  peakidx_s[0] = T; peakidx_s[1] = 1;

  peakidx_m = mxCreateNumericArray(2, peakidx_s, mxUINT32_CLASS, mxREAL);
  peakidx = mxGetPr(peakidx_m);

  N = maxima_core(data,T,frc,peakidx);
  
  plhs[0] = mxCreateDoubleMatrix(N,1, mxREAL);
  idxout = mxGetPr(plhs[0]);
  for (n=0; n<N; n++)
    idxout[n] = peakidx[n] + 1;

  mxDestroyArray(peakidx_m);
}
