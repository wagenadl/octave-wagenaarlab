/* xcorg_int.c - mexglx implementation of xcorg_int:

% xc = XCORG_INT(ttx,tty,T) computes the cross-correlation between two
% time series TTX and TTY, which must be arrays of non-negative int32s,
% pre-sorted in non-decreasing order. 
% Only the TTY-after-TTX part of the correlogram is calculated, and only
% the first T bins are, i.e. bins tty==ttx+0 up to tty==ttx+T-1.

  (C) Daniel Wagenaar, July 25th, 2004.
*/

#include "mex.h"
#include "matrix.h"

int xcorg_int(unsigned int *dst, unsigned int ndst,
	      unsigned int const *ttx, unsigned int nx,
	      unsigned int const *tty, unsigned int ny) {
  unsigned int tx, ty;
  unsigned int ix, iy, jy;
  unsigned int idst;

  for (idst=0; idst<ndst; idst++)
    dst[idst]=0;

  ix=0; iy=0;
  while (ix<nx && iy<ny) {
    /* Step to next time point in series X */
    tx = ttx[ix]; ix++;

    /* Search for first time point in series Y not before current point in X */
    while (iy<ny && tty[iy]<tx)
      iy++;

    /* Look at all relevant points in Y and update output. */
    jy=iy;
    while (jy<ny && (ty=tty[jy])<tx+ndst) {
      if (ty<tx) {
	/* violation of assumption */
	return 0;
      }
      dst[ty-tx]++;
      jy++;
    }
  }    
  return 1;
}

int checkVecInt(const mxArray *prhs) { 
  int ndim, realdims, idim;
  int const *dims;

  if (!mxIsUint32(prhs) || mxIsComplex(prhs))
    mexErrMsgTxt("First two arguments must be uint32.");

  ndim = mxGetNumberOfDimensions(prhs);
  dims = mxGetDimensions(prhs);
  realdims=0;
  for (idim=0; idim<ndim; idim++)
    realdims += dims[idim]>1;
  if (realdims>1)
    mexErrMsgTxt("First two arguments must be vectors.");

  return mxGetM(prhs) * mxGetN(prhs);
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[]) {
  unsigned int *out_xc;
  unsigned int const *in_ttx;
  unsigned int const *in_tty;
  unsigned int in_T;

  int nx, ny;

  if (nrhs!=3)
    mexErrMsgTxt("Must have precisely three arguments.");
  if (nlhs!=1)
    mexErrMsgTxt("Must have precisely one output.");

  nx = checkVecInt(prhs[0]);  
  ny = checkVecInt(prhs[1]);

  if (mxGetN(prhs[2])*mxGetM(prhs[2]) != 1)
    mexErrMsgTxt("Third input must be a scalar.");

  in_T = (unsigned int)mxGetScalar(prhs[2]);

  in_ttx = (unsigned int *)mxGetData(prhs[0]);
  in_tty = (unsigned int *)mxGetData(prhs[1]);

  plhs[0] = mxCreateNumericMatrix(1,in_T, mxUINT32_CLASS, 0);
  out_xc = (unsigned int *)mxGetData(plhs[0]);

  if (!xcorg_int(out_xc,in_T, in_ttx,nx, in_tty,ny)) {
    /* violation of assumption */
    mexErrMsgTxt("Vectors must be in non-decreasing order.");
  }

}

/* test code:

xc = xcorg_int(uint32([10 20 30 40 50]),uint32([11 22 51 54 57]),10);

*/
