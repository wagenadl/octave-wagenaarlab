/* dilerode.c - mex function for image erosion and dilation */

#define OP_ERODE4 1
#define OP_ERODE8 2
#define OP_DILATE4 3
#define OP_DILATE8 4
#define OP_EDGE4 5
#define OP_EDGE8 6
#define OP_THIN 7
#define OP_SKEL 8

#include "mex.h"
#include <string.h>


/* static unsigned char protectable4[16]; */
static unsigned char protectable8[256];
static unsigned char protectable_initialized = 0;

static void initialize_protectable4(void) {
  /*
  unsigned char *pr = protectable4;
  memset((void*)pr,0,16);
  pr[0] = 1;
  pr[1] = pr[2] = pr[4] = pr[8] = 1;
  pr[1+2] = pr[1+4] = pr[1+8] = 1;
  pr[2+4] = pr[2+8] = 1;
  pr[4+8] = 1;
  */
}

static void setpr(unsigned char *pr, int x) {
  x=x|(x>>8);
  pr[x&255]=1;
}

static void initialize_protectable8(void) {
  unsigned char *pr = protectable8;
  int k,l;
  memset((void*)pr,0,256);
  /* protect solo pixels */
  pr[0] = 1;

  /* protect end pixels */
  for (k=1; k<256; k*=2) 
    setpr(pr,k);
  for (k=1; k<256; k*=2)
      setpr(pr,k*3); 

  /* protect connecting pixels */
  for (k=1; k<256; k*=4) {
    for (l=1; l<8; l++) {
      setpr(pr,k+k*8*l);
      setpr(pr,k*(1+2)+k*8*l);
      setpr(pr,k*(1+128)+k*8*l);
      setpr(pr,k*(1+2+128)+k*8*l);
    }
  }

  for (k=2; k<256; k*=4) 
    for (l=1; l<32; l++) 
      setpr(pr,k+4*k*l);
}

static void ensure_protectable(void) {
  if (!protectable_initialized) {
    initialize_protectable4();
    initialize_protectable8();
    protectable_initialized = 1;
  }
}

/*
static int neighborhood4(unsigned char const *pix, int X) {
  return (pix[1] ? 1 : 0) +
    (pix[-X] ? 2 : 0) +
    (pix[-1] ? 4 : 0) +
    (pix[X] ? 8 : 0);
}
*/

static int neighborhood8(unsigned char const *pix, int X) {
  return (pix[1] ? 1 : 0) +
    (pix[1-X] ? 2 : 0) +
    (pix[-X] ? 4 : 0) +
    (pix[-1-X] ? 8 : 0) +
    (pix[-1] ? 16 : 0) +
    (pix[-1+X] ? 32 : 0) +
    (pix[X] ? 64 : 0) +
    (pix[1+X] ? 128 : 0);
}


static void op_erode4(unsigned char const *img, int X, int Y,
		      unsigned char *im1) {
  int x, y;
  for (y=1; y<Y-1; y++) {
    unsigned char const *row = img + y*X;
    unsigned char *row1 = im1 + y*X;
    for (x=1; x<X-1; x++) {
      unsigned char const *pix = row + x;
      if (*pix) {
	/* This pixel is set, so it could be eroded away */
	if (!pix[-1] || !pix[1] || !pix[-X] || !pix[X])
	  row1[x] = 0;
      }
    }
  }
}

static void op_erode8(unsigned char const *img, int X, int Y, 
		      unsigned char *im1) {
  int x, y;
  for (y=1; y<Y-1; y++) {
    unsigned char const *row = img + y*X;
    unsigned char *row1 = im1 + y*X;
    for (x=1; x<X-1; x++) {
      unsigned char const *pix = row + x;
      if (*pix) {
	/* This pixel is set, so it could be eroded away */
	if (!pix[-1] || !pix[1] || !pix[-X] || !pix[X] ||
	    !pix[-1-X] || !pix[1-X] || !pix[-1+X] || !pix[1+X])
	  row1[x] = 0;
      }
    }
  }
}

void op_dilate4(unsigned char const *img, int X, int Y, 
		unsigned char *im1) {
  int x, y;
  for (y=1; y<Y-1; y++) {
    unsigned char const *row = img + y*X;
    unsigned char *row1 = im1 + y*X;
    for (x=1; x<X-1; x++) {
      unsigned char const *pix = row + x;
      if (!*pix) {
	/* This pixel is not set, so it could be dilated onto */
	if (pix[-1] || pix[1] || pix[-X] || pix[X])
	  row1[x] = 1;
      }
    }
  }
}
	
void op_dilate8(unsigned char const *img, int X, int Y, 
		unsigned char *im1) {
  int x, y;
  for (y=1; y<Y-1; y++) {
    unsigned char const *row = img + y*X;
    unsigned char *row1 = im1 + y*X;
    for (x=1; x<X-1; x++) {
      unsigned char const *pix = row + x;
      if (!*pix) {
	/* This pixel is not set, so it could be dilated onto */
	if (pix[-1] || pix[1] || pix[-X] || pix[X] ||
	    pix[-1-X] || pix[1-X] || pix[-1+X] || pix[1+X])
	  row1[x] = 1;
      }
    }
  }
}

static void pop_andnot(unsigned char const *img, int X, int Y,
		     unsigned char *im1) {
  int x, y;
  for (y=0; y<Y; y++) {
    unsigned char const *row = img + y*X;
    unsigned char *row1 = im1 + y*X;
    for (x=0; x<X; x++) {
      *row1 = (*row && !*row1) ? 1 : 0;
      row++;
      row1++;
    }
  }
}

static void op_edge4(unsigned char const *img, int X, int Y,
		     unsigned char *im1) {
  op_erode4(img, X, Y, im1);
  pop_andnot(img, X, Y, im1);
}

static void op_edge8(unsigned char const *img, int X, int Y,
		     unsigned char *im1) {
  op_erode8(img, X, Y, im1);
  pop_andnot(img, X, Y, im1);
}

static void op_thin(unsigned char const *img, int X, int Y,
		    unsigned char *im1) {
  int x, y;
  ensure_protectable();
  for (y=1; y<Y-1; y++) {
    unsigned char const *row = img + y*X;
    unsigned char *row1 = im1 + y*X;
    for (x=1; x<X-1; x++) {
      unsigned char const *pix = row + x;
      if (*pix) {
	/* This pixel is set, so it could be eroded away */
	if (!pix[-1] || !pix[1] || !pix[-X] || !pix[X])
	  if (!protectable8[neighborhood8(row1+x,X)])
	    row1[x] = 0;
      }
    }
  }
}

static int pop_equal(unsigned char const *img, int X, int Y,
		     unsigned char const *im1) {
  int x, y;
  for (y=0; y<Y; y++)
    for (x=0; x<X; x++)
      if (*img++ != *im1++)
	return 0;
  return 1;
}

static void op_skel(unsigned char const *img, int X, int Y,
		    unsigned char *im1) {
  void *mem = mxCalloc(X*Y,1);
  unsigned char *im2 = (unsigned char *)mem;
  while (1) {
    memcpy(im2,im1,X*Y);
    op_thin(im1, X, Y, im2);
    if (pop_equal(im1, X, Y, im2)) {
      mxFree(mem);
      return;
    }
    memcpy(im1,im2,X*Y);
  }
}

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]) {
  int X, Y;
  int xy[2];
  int op;
  unsigned char const *im0;
  unsigned char *im1;
  if (nrhs!=2)
    mexErrMsgTxt("Usage: im1=dilerode(im0,op)");
  if (!mxIsClass(prhs[0], "uint8"))
    mexErrMsgTxt("im0 must be uint8");
  X = mxGetM(prhs[0]);
  Y = mxGetN(prhs[0]);
  im0 = (unsigned char const *)mxGetPr(prhs[0]);
  op = (int)mxGetScalar(prhs[1]);

  xy[0] = X;
  xy[1] = Y;
  plhs[0] = mxCreateNumericArray(2,xy,mxUINT8_CLASS,mxREAL);
  im1 = (unsigned char *)mxGetPr(plhs[0]);
  memcpy(im1, im0, X*Y);

  switch (op) {
  case OP_ERODE4: op_erode4(im0, X, Y, im1); break;
  case OP_ERODE8: op_erode8(im0, X, Y, im1); break;
  case OP_DILATE4: op_dilate4(im0, X, Y, im1); break;
  case OP_DILATE8: op_dilate8(im0, X, Y, im1); break;
  case OP_EDGE4: op_edge4(im0, X, Y, im1); break;
  case OP_EDGE8: op_edge8(im0, X, Y, im1); break;
  case OP_THIN: op_thin(im0, X, Y, im1); break;
  case OP_SKEL: op_skel(im0, X, Y, im1); break;
  default: mexErrMsgTxt("Unknown operation");
  }
}
