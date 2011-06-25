/* crossseriesmatch_core.c */

#include "mex.h"

int findfirst_ge(double const *src, double tst, int m, int n) {
  int i;
  for (i=m; i<n; i++) 
    if (src[i]>=tst)
      return i+1;
  return 0;
}

void csm(double const *tt1, double const *tt2, int n1, int n2, int *dst) {
  int k;
  int l0=0;
  for (k=0; k<n1; k++) {
    int l = findfirst_ge(tt2,tt1[k],l0,n2);
    dst[k] = l;
    if (dst[k])
      l0=l-1;
    else
      l0=n2;
  }
}


/* The gateway routine */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *tt1, *tt2;
  int *idxout;
  int n1, n2;
  
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
  
  /* Check to make sure the first input argument is a vector. */
  if( !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
      (mxGetN(prhs[0])>1 && mxGetM(prhs[0])>1) ) {
    mexErrMsgTxt("Input 1 must be a vector.");
  }
  /* Check to make sure the second input argument is a vector. */
  if( !mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) ||
      (mxGetN(prhs[1])>1 && mxGetM(prhs[1])>1) ) {
    mexErrMsgTxt("Input 2 must be a vector.");
  }

  tt1 = mxGetPr(prhs[0]);
  tt2 = mxGetPr(prhs[1]);
  
  /*  Get the dimensions of the vector input x. */
  n1 = mxGetM(prhs[0]) * mxGetN(prhs[0]);
  n2 = mxGetM(prhs[1]) * mxGetN(prhs[1]);
  
  /*  Set the output pointer to the output matrix. */
  plhs[0] = mxCreateNumericMatrix(n1,1, mxINT32_CLASS,mxREAL);
  
  /*  Create a C pointer to a copy of the output matrix. */
  idxout = (int*)mxGetPr(plhs[0]);
  
  /*  Call the C subroutine. */
  csm(tt1,tt2,n1,n2,idxout);
  
}
