/* stat_core.c - heavily based on xtimesy.c in the matlab examples */

#include "mex.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include <sys/time.h>
#include <time.h>

#include <stdio.h>

/* The gateway routine */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  char fn[1000];
  struct stat buf;
  struct timeval tv;
  struct timezone tz;
  int *arout;
  int     status,mrows,ncols;
  
  /*  Check for proper number of arguments. */
  /* NOTE: You do not need an else statement when using
     mexErrMsgTxt within an if statement. It will never
     get to the else statement if mexErrMsgTxt is executed.
     (mexErrMsgTxt breaks you out of the MEX-file.) 
 */
  if(nrhs!=1) 
    mexErrMsgTxt("One input required.");
  if(nlhs!=1) 
    mexErrMsgTxt("One output required.");
  
  /* Check to make sure the first input argument is a string. */
  if( !mxIsChar(prhs[0]) ||
      (mxGetN(prhs[0])>1 && mxGetM(prhs[0])>1) ) 
    mexErrMsgTxt("Input x must be a string.");

  if (mxGetString(prhs[0],fn,999))
    mexErrMsgTxt("Input x must be a string.");
  
  /*  Create a C pointer to a copy of the output matrix. */
  plhs[0] = mxCreateNumericMatrix(1,14, mxINT32_CLASS,mxREAL);
  arout = (int*)(mxGetData(plhs[0]));
  
  /* Do the work */
  if (stat(fn,&buf)) {
    perror("stat_core");
    mexErrMsgTxt("Cannot stat file");
  }
  arout[0] = buf.st_dev;
  arout[1] = buf.st_ino;
  arout[2] = buf.st_mode;
  arout[3] = buf.st_nlink;
  arout[4] = buf.st_uid;
  arout[5] = buf.st_gid;
  arout[6] = buf.st_rdev;
  arout[7] = buf.st_size;
  arout[8] = buf.st_blksize;
  arout[9] = buf.st_blocks;
  arout[10] = buf.st_atime;
  arout[11] = buf.st_mtime;
  arout[12] = buf.st_ctime;

  if (gettimeofday(&tv, &tz)) {
    arout[13] = 0;
  } else {
    arout[13] = tz.tz_minuteswest * 60;
  }
}
