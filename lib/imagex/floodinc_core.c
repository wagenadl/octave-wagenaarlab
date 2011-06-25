/* imobjectify_core.c - mex function for imobjectify. 
   Do not call directly.
*/

#include "mex.h"
#include <string.h>

static unsigned char op_saferead(unsigned char const *img, int X, int Y,
			      int x, int y) {
  if (x>=0 && x<X && y>=0 && y<Y)
    return img[x+y*X];
  else
    return 0;
}

static unsigned int op_safereado(unsigned int const *img, int X, int Y,
				  int x, int y) {
  if (x>=0 && x<X && y>=0 && y<Y)
    return img[x+y*X];
  else
    return 0;
}

#define setpix(x,y,k) obj[(x)+(y)*X] = k

#define maybeadd(dx,dy) \
  if (op_saferead(img,X,Y,x+dx,y+dy) &&	\
      !op_safereado(obj,X,Y,x+dx,y+dy)) { \
    if (Nnew>=Nalloc) { \
      Nalloc = 2*Nalloc; \
      oldpile = (coord*)mxRealloc((void*)oldpile,Nalloc*sizeof(coord));	\
      newpile = (coord*)mxRealloc((void*)newpile,Nalloc*sizeof(coord)); \
    }							  \
    newpile[Nnew].x = x+dx; \
    newpile[Nnew].y = y+dy; \
    setpix(x+dx,y+dy,k); \
    Nnew++; \
  }

typedef struct {
  int x;
  int y;
} coord;

static void op_flood(unsigned char const *img, int X, int Y,
		     unsigned int *obj, int x, int y) {
  int k = 1;
  int Nalloc = 1024;
  int Nold = 0;
  int Nnew = 0;
  coord *oldpile = (coord*)mxMalloc(Nalloc*sizeof(coord));
  coord *newpile = (coord*)mxMalloc(Nalloc*sizeof(coord));
  oldpile[0].x = x;
  oldpile[0].y = y;
  Nold = 1;
  setpix(x,y,k);
  while (Nold>0) {
    k++;
    Nnew = 0;
    int iold;
    coord *swap;
    for (iold=0; iold<Nold; iold++) {
      int x = oldpile[iold].x;
      int y = oldpile[iold].y;
      maybeadd(-1,-1);
      maybeadd(0,-1);
      maybeadd(1,-1);
      maybeadd(-1,0);
      maybeadd(1,0);
      maybeadd(-1,1);
      maybeadd(0,1);
      maybeadd(1,1);
    }
    swap = oldpile;
    oldpile = newpile;
    newpile = swap;
    Nold = Nnew;
  }
  mxFree((void*)oldpile);
  mxFree((void*)newpile);
}

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]) {
  int X, Y;
  int x, y;
  int xy[2];
  unsigned char const *img;
  unsigned int *obj;

  Y = mxGetN(prhs[0]);
  X = mxGetM(prhs[0]);
  img = (unsigned char const *)mxGetPr(prhs[0]);
  x = (int)mxGetScalar(prhs[1]);
  y = (int)mxGetScalar(prhs[2]);

  xy[0] = X;
  xy[1] = Y;
  plhs[0] = mxCreateNumericArray(2,xy,mxUINT32_CLASS,mxREAL);
  obj = (unsigned int *)mxGetPr(plhs[0]);
  op_flood(img, X, Y, obj, x, y);
}
