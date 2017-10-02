/* findlast.c - heavily based on xtimesy.c in the matlab examples */

#include "mex.h"

int findlast(double const *src, double tst, int n) {
  int i;
  for (i=n-1; i>=0; i--) 
    if (src[i]<=tst)
      return i+1;
  return 0;
}

/* The gateway routine */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *haystack;
  double  needle;
  double *idxout;
  int     status,mrows,ncols;
  
  /*  Check for proper number of arguments. */
  /* NOTE: You do not need an else statement when using
     mexErrMsgTxt within an if statement. It will never
     get to the else statement if mexErrMsgTxt is executed.
     (mexErrMsgTxt breaks you out of the MEX-file.) 
 */
  if(nrhs!=2) 
    mexErrMsgTxt("Two inputs required.");
  if(nlhs!=1) 
    mexErrMsgTxt("One output required.");
  
  /* Check to make sure the last input argument is a vector. */
  if( !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
      (mxGetN(prhs[0])>1 && mxGetM(prhs[0])>1) ) {
    mexErrMsgTxt("Input x must be a vector.");
  }

  /* Check to make sure the second input argument is a scalar. */
  if( !mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) ||
      mxGetN(prhs[1])*mxGetM(prhs[1])!=1 ) {
    mexErrMsgTxt("Input y must be a scalar.");
  }
  
  /*  Get the scalar input y. */
  needle = mxGetScalar(prhs[1]);
  
  /*  Create a pointer to the input vector x. */
  haystack = mxGetPr(prhs[0]);
  
  /*  Get the dimensions of the vector input x. */
  mrows = mxGetM(prhs[0]);
  ncols = mxGetN(prhs[0]);
  
  /*  Set the output pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);
  
  /*  Create a C pointer to a copy of the output matrix. */
  idxout = mxGetPr(plhs[0]);
  
  /*  Call the C subroutine. */
  *idxout = findlast(haystack,needle,mrows*ncols);
  
}
