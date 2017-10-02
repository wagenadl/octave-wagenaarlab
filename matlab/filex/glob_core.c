/* glob_core.c */

#include "mex.h"
#include "matrix.h"

#include <glob.h>
#include <string.h>

void mexFunction(int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[]) {

  char pat[1000];
  glob_t pglob;
  int k;

  if(nrhs!=1) 
    mexErrMsgTxt("One input required.");
  if(nlhs!=1) 
    mexErrMsgTxt("One output required.");
 
  if (!mxIsChar(prhs[0]) || (mxGetN(prhs[0])>1 && mxGetM(prhs[0])>1)) 
    mexErrMsgTxt("Input PAT must be a string.");
  if (mxGetString(prhs[0],pat,999))
    mexErrMsgTxt("Input PAT must be a string.");
  
  if (glob(pat,GLOB_TILDE,0,&pglob)) {
    /* On error, return an empty cell array */
    perror("glob");
    plhs[0] = mxCreateCellMatrix(0,0);
    return;
  }

  plhs[0] = mxCreateCellMatrix(pglob.gl_pathc,1);

  for (k=0; k<pglob.gl_pathc; k++) {
    mxArray *fn = mxCreateString(pglob.gl_pathv[k]);
    mxSetCell(plhs[0],k,fn);
  }

  globfree(&pglob);
}
