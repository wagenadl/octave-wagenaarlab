/* unhist_core.c */

#include "mex.h"

typedef unsigned int int_type;

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *xxx;
  double *xx;
  int_type *nn;
  int_type L;
  int_type N;
  int_type l;
  int_type n;
 
  if (nrhs!=2) 
    mexErrMsgTxt("Two inputs required.");
  if (nlhs!=1) 
    mexErrMsgTxt("One output required.");

  L=mxGetN(prhs[0]) * mxGetM(prhs[0]);
  if (L!=mxGetN(prhs[1])*mxGetM(prhs[1]))
    mexErrMsgTxt("Inputs must be same size.");

  if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]))
    mexErrMsgTxt("First input must be real array");

  if (!mxIsUint32(prhs[1]))
    mexErrMsgTxt("Second input must be integer array");

  xx = mxGetPr(prhs[0]);
  nn = (int_type*)(mxGetPr(prhs[1]));
  
  N=0;
  for (l=0; l<L; l++)
    N+=nn[l];

  plhs[0] = mxCreateDoubleMatrix(N,1,mxREAL);
  xxx = mxGetPr(plhs[0]);

  N=0;
  for (l=0; l<L; l++)
    for (n=0; n<nn[l]; n++)
      xxx[N++] = xx[l];
}
