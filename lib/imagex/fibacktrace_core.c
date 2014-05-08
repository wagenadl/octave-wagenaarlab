/* fibacktrace_core.c - mex function for fibacktrace. 
   Do not call directly.
*/

#include "mex.h"
#include <stdio.h>

static unsigned int saferead(unsigned int const *img, int X, int Y,
			      int x, int y) {
  if (x>=0 && x<X && y>=0 && y<Y)
    return img[x+y*X];
  else
    return 0;
}

typedef struct {
  int x;
  int y;
} coord;

#define tryimprove(dx,dy) \
  tmp = saferead(obj,X,Y,x+dx,y+dy);		\
  if (tmp>0 && tmp<best) {	 \
    best = tmp;			 \
    dxbest = dx;		 \
    dybest = dy;		 \
  }


static coord *op_fiback(unsigned int const *obj, int X, int Y,
			int x, int y, int *nused) {
  int Nalloc = 1024;
  int Nused = 0;
  coord *dest = (coord*)mxMalloc(Nalloc*sizeof(coord));
  while (1) {
    int tmp;
    int best = saferead(obj,X,Y,x,y);
    int dxbest = 0;
    int dybest = 0;
    dest[Nused].x = x;     
    dest[Nused].y = y;
    Nused++;
    tryimprove(0,-1);
    tryimprove(-1,0);
    tryimprove(1,0);
    tryimprove(0,1);
    tryimprove(-1,-1);
    tryimprove(1,-1);
    tryimprove(-1,1);
    tryimprove(1,1);
    if (dxbest || dybest) {
      if (Nused>=Nalloc) {
	Nalloc = Nalloc*2;
	dest = (coord*)mxRealloc((void*)dest, Nalloc*sizeof(coord));
      }
      x+=dxbest;
      y+=dybest;
    } else {
      break;
    }
  }
  *nused = Nused;
  return dest;
}

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]) {
  int X, Y;
  int x, y;
  int xy[2];
  unsigned int const *img;
  unsigned int *obj;
  coord *dest;
  int nused;

  Y = mxGetN(prhs[0]);
  X = mxGetM(prhs[0]);
  img = (unsigned int const *)mxGetPr(prhs[0]);
  x = (int)mxGetScalar(prhs[1]);
  y = (int)mxGetScalar(prhs[2]);

  dest = op_fiback(img,X,Y,x,y,&nused);

  xy[0] = 2;
  xy[1] = nused;
  plhs[0] = mxCreateNumericArray(2,xy,mxUINT32_CLASS,mxREAL);
  obj = (unsigned int *)mxGetPr(plhs[0]);
  for (x=0; x<nused; x++) {
    *obj++ = dest->x;
    *obj++ = dest->y;
    dest++;
  }
}
