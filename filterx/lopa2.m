function yy = lopa2(xx,tau)
% yy = LOPA2(xx,tau) [pronounce "low-pass"] filters the array XX
% twice, once in forward direction along first dimension, once in
% backward direction along first dimension.
% TAU is the low-pass corner frequency 0<TAU<1. (Small TAU means
% agressive filtering.)
% Currently only defined for vectors or matrices, not 3+ dim arrays.

a = [ 1, tau-1];
b = [ tau, 0];

[L D] = size(xx);
if L==1
  flip=1;
  xx=xx';
  [L D] = size(xx);
else
  flip=0;
end

N=ceil(5/tau);
yy = [ zeros(N,D); xx; zeros(N,D) ];
yy = filter(b,a,yy);
yy = flipud(filter(b,a,flipud(yy)));
yy = yy(N+1:N+L,:);

if flip
  yy=yy';
end