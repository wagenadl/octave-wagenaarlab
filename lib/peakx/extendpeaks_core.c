/* extendpeaks_core.c - see extendpeaks.m */

/* 
gcc -c -W -Wall -I/usr/local/matlabR14student/extern/include \
  -I/usr/local/matlabR14student/simulink/include \
  -DMATLAB_MEX_FILE -fPIC -ansi -D_GNU_SOURCE -pthread -m32  \
  -O -DNDEBUG extendpeaks_core.c && \
gcc -c  -I/usr/local/matlabR14student/extern/include \
  -I/usr/local/matlabR14student/simulink/include \
  -DMATLAB_MEX_FILE -fPIC -ansi -D_GNU_SOURCE -pthread -m32  \
  -O -DNDEBUG /usr/local/matlabR14student/extern/src/mexversion.c && \
gcc -O -pthread -shared -m32 \
  -Wl,--version-script,/usr/local/matlabR14student/extern/lib/glnx86/mexFunction.map \
  -o extendpeaks_core.mexglx extendpeaks_core.o mexversion.o  \
  -Wl,--rpath-link,/usr/local/matlabR14student/bin/glnx86 \
  -L/lib32 -L/usr/lib32 -L/usr/local/matlabR14student/bin/glnx86 \
  -lmx -lmex -lmat -lm
*/

#include "mex.h"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

void extendpeaks_core(double const *yy, int Nyy,
		      int const *pkpos, int Npk,
		      double thr,
		      int *pkno /*output*/) {
  int iyy, ipk;
  for (iyy=0; iyy<Nyy; iyy++)
    pkno[iyy]=0;

  for (ipk=0; ipk<Npk; ipk++) {
    for (iyy = pkpos[ipk]; iyy>=0 && yy[iyy]>=thr; iyy--)
      pkno[iyy]=ipk+1;
    for (iyy = pkpos[ipk]+1; iyy<Nyy && yy[iyy]>=thr; iyy++)
      pkno[iyy]=ipk+1;
  }
}


void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[]) {
  int N_y, M_y, L_pkpos, L_thr;
  double const *yy;
  int const *pkpos;
  double const *thr;
  int *pkno;
  fprintf(stderr,"extendpeaks_core\n");
  if(nlhs!=1) 
    mexErrMsgTxt("One output required.");
  if(nrhs!=7) 
    mexErrMsgTxt("Three inputs required.");
  if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]))
    mexErrMsgTxt("YY must be real doubles");
  if (!mxIsInt32(prhs[1]) || mxIsComplex(prhs[1]))
    mexErrMsgTxt("PKPOS must be real integers");
  if (!mxIsDouble(prhs[2]) || mxIsComplex(prhs[2]))
    mexErrMsgTxt("THR must be a real double scalar");

  fprintf(stderr,"Checked inputs\n");

  M_y = mxGetM(prhs[0]); 
  N_y = mxGetN(prhs[0]);
  L_pkpos = mxGetM(prhs[1])*mxGetN(prhs[1]);
  L_thr = mxGetM(prhs[2])*mxGetN(prhs[2]);

  fprintf(stderr,"Computed sizes\n");

  if (L_thr!=1)
    mexErrMsgTxt("THR must be a real double scalar");

  yy = (double const*)mxGetData(prhs[0]);
  pkpos = (int const*)mxGetData(prhs[1]);
  thr = (double const*)mxGetData(prhs[2]);

  fprintf(stderr,"yy=%p pkpos=%p thr=%p\n",yy,pkpos,thr);
  fprintf(stderr,"M_y=%i N_y=%i L_pkpos=%i\n",M_y,N_y,L_pkpos);

  mxDestroyArray(plhs[0]);
  fprintf(stderr,"Removed old plhs[0]\n");
  plhs[0] = mxCreateNumericMatrix(M_y,N_y,mxINT32_CLASS,mxREAL);
  fprintf(stderr,"Created new plhs[0]\n");
  pkno = (int*)mxGetData(plhs[0]);
  fprintf(stderr,"pkno=%p\n",pkno);
  extendpeaks_core(yy, M_y*N_y, pkpos, L_pkpos, *thr, pkno);

  return;
}
