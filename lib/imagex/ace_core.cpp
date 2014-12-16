// ace_core.cpp

#include <mex.h>
#include "DoubleImage.cpp"
#include <string.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  if (nrhs != 2) 
    mexErrMsgTxt("Two inputs required.");
  if (nlhs != 1) 
    mexErrMsgTxt("One output required.");

  int height = mxGetM(prhs[0]);
  int width = mxGetN(prhs[0]);
  double const *data = mxGetPr(prhs[0]);
  double const *pars = mxGetPr(prhs[1]);
  double sigx = pars[0];
  int rx = int(pars[1]);
  double sigy = pars[2];
  int ry = int(pars[3]);
  DoubleImage img(data, width, height);
  DoubleImage res(img.ace(sigx, rx, sigy, ry));
  plhs[0] = mxCreateDoubleMatrix(height, width, mxREAL);
  memcpy(mxGetPr(plhs[0]), res.data(), sizeof(double)*width*height);
}
