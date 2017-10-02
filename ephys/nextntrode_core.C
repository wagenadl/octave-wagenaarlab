// nextntrode.C

#include "mex.h"
#include "matrix.h"
#include <stdint.h>

inline int bitcount(long long x) {
  int cnt = 0;
  while (x) {
    cnt += x & 1;
    x >>= 1;
  }
  return cnt;
}

inline int firstzero(long long x) {
  const long long one = 1;
  int bit = 0;
  while (x & (one<<bit)) {
    bit++;
  }
  return bit;
}

inline int firstone(long long x) {
  const long long one = 1;
  int bit = 0;
  while (!(x & (one<<bit))) {
    bit++;
  }
  return bit;
}

void nextntrode(int32_t *tetrode, int K, int E) {
  /* Input: tetrode: current contents of tetrode, e.g., [0, 3, 4, 49].
            E: number of total electrodes (e.g., 60)
            K: number of electrodes in the tetrode.
     Output: tetrode is replaced with next tetrode, in this case:
             [1, 3, 4, 49].
  */
  long long bits = 0;
  long long one = 1;
  for (int k=0; k<K; k++)
    bits |= one<<tetrode[k];

  // We are going to increment bits until we have the same number of bits set.
  int count = K;
  do {
    if (count>=K) {
      // We have a good number or too many ones.
      // Let's flip the first '1'. That may work. Certainly flipping any
      // earlier zero will only make matters worse.
      bits += one<<firstone(bits);
    } else {
      // We have too few ones.
      // Let's flip the first '0'. That may work.
      bits += one<<firstzero(bits);
    }
    count = bitcount(bits);
  } while (count!=K);

  int k=0;
  int bit = 0;
  while (bits) {
    if (bits & (one<<bit)) {
      tetrode[k] = bit;
      bits &= ~(one<<bit);
      k++;
    }
    bit++;
  }
}


void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]) {
  /* Input: #1: vector of int32_ts: electrodes in tetrode (count from 0)
            #2: scalar int32_t: total number of electrode
     Output: #1: vector of int32_ts: electrodes in new tetrode
  */
            
  int32_t E;
  int32_t K;
  int32_t const *src;
  int32_t *dst;

  if (nrhs!=2)
    mexErrMsgTxt("Two inputs required.");
  if (mxGetClassID(prhs[0])!=mxINT32_CLASS || mxIsComplex(prhs[0]) ||
      (mxGetN(prhs[0])!=1 && mxGetM(prhs[0])!=1)) 
    mexErrMsgTxt("Input 1 must be a vector of int32_t.");
  if (mxGetClassID(prhs[1])!=mxINT32_CLASS || mxIsComplex(prhs[1]) ||
      (mxGetN(prhs[1])!=1 || mxGetM(prhs[1])!=1)) 
    mexErrMsgTxt("Input 2 must be a scalar of int32_t.");
  
  if (nlhs!=1) 
    mexErrMsgTxt("One output required.");
  plhs[0] = mxCreateNumericMatrix(mxGetM(prhs[0]), mxGetN(prhs[0]),
				  mxINT32_CLASS, false);
  
  src = (int32_t const *)mxGetData(prhs[0]);
  K = mxGetN(prhs[0]) * mxGetM(prhs[0]);
  E = *(int32_t const *)mxGetData(prhs[1]);
  dst = (int32_t *)mxGetData(plhs[0]);

  for (int k=0; k<K; k++)
    dst[k] = src[k];

  nextntrode(dst, K, E); 
}
