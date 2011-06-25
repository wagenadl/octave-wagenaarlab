/* binsearch_core.c */

#include "mex.h"

int binsearch(double const *xx, double y, int N0, int N1) {
  int n=N1;
    while (N0<N1) {
    n = (N0+N1)/2;
    if (xx[n]>=y) {
      N1=n;
    } else {
      N0=n+1;
    } 
  }
  return N1;
}
 
void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]) {
  double *xx;
  double y;
  double *idxout;
  int N;
  
  if (nrhs!=2) 
    mexErrMsgTxt("Two inputs required.");
  if(nlhs!=1) 
    mexErrMsgTxt("One output required.");
    if( !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
      (mxGetN(prhs[0])>1 && mxGetM(prhs[0])>1) ) {
    mexErrMsgTxt("Input xx must be a vector.");
  }

  /* Check to make sure the second input argument is a scalar. */
  if( !mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) ||
      mxGetN(prhs[1])*mxGetM(prhs[1])!=1 ) {
    mexErrMsgTxt("Input y must be a scalar.");
  }
  
  /*  Get the scalar input y. */
  y = mxGetScalar(prhs[1]);
  
  /*  Create a pointer to the input vector x. */
  xx = mxGetPr(prhs[0]);

  N = mxGetM(prhs[0])*mxGetN(prhs[0]);  

  /*  Set the output pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);
  
  /*  Create a C pointer to a copy of the output matrix. */
  idxout = mxGetPr(plhs[0]);
  
  /*  Call the C subroutine. */
  *idxout = binsearch(xx,y,0,N);
}
