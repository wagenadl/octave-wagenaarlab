// salpamex.C

#if 0
mex salpamex.C LocalFit.C
#endif

#include <mex.h>
#include "LocalFit.H"
  
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  /* Input arguments are:
     data: Tx1 - Input
     opts: [ rail1, rail2, thresh, tau, t_blankdepeg, t_ahead, t_chi2 ]
     Output argument:
     yy: Tx1 - Filtered output
  */
  double *data;
  double *opts;
  double *out;
  int T;
    
  if(nrhs!=2) 
    mexErrMsgTxt("Two inputs required.");
  if(nlhs!=1) 
    mexErrMsgTxt("One output required.");
  
  /* Check to make sure the first_gt input argument is a vector. */
  if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
      (mxGetN(prhs[0])>1 && mxGetM(prhs[0])>1))
    mexErrMsgTxt("Input 1 must be a real vector.");
  if (!mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) ||
      mxGetN(prhs[0])*mxGetM(prhs[1])!=7) 
    mexErrMsgTxt("Input 2 must be a real vector of 7 elements.");

  plhs[0] = mxCreateDoubleMatrix(mxGetN(prhs[0]),mxGetM(prhs[0]),mxREAL);

  T=mxGetN(prhs[0]) * mxGetM(prhs[0]);
  data=mxGetPr(prhs[0]);
  opts=mxGetPr(prhs[1]);
  out=mxGetPr(plhs[0]);

  LocalFit lf(data,out,0,
	      opts[2],  // threshold
	      int(opts[3]),  // tau
	      int(opts[4]),  // t_blankdepeg
	      int(opts[5]),  // t_ahead
	      int(opts[6])); // t_chi2
  lf.setrail(opts[0],opts[1]);
  lf.process(T);
}
