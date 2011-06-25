function [dt,cc] = fxcorgt(tx,ty,dt0,t0,odd)
% [dt,cc] = FXCORGT(tx,ty,dt,t0) calculates the crosscorrelation between
% the timeseries TX and TY, sampled at resolution DT, and going out T0
% away from zero. By default, the number of bins is even.
% [dt,cc] = FXCORGT(tx,ty,dt,t0,1) makes the number of bins be odd.
% Positive output DT corresponds with XX leading YY.

if nargin<5
  odd=0;
end
tm = min([min(tx) min(ty)]);
tM = max([max(tx) max(ty)]);
tt = [tm-t0-3*dt0:dt0:tM+t0+3*dt0];
N=length(tt);
if mod(N,2)~=odd
  tt=tt(1:end-1);
end
xx=hist(tx,tt);
yy=hist(ty,tt);
cc = ifft(conj(fft(xx)).*fft(yy));
N=length(tt);
if mod(N,2)
  L=N/2-.5;
  cc = [cc(end-L+1:end) cc(1:L+1)];
  dt = [-L:L]*dt0;
else
  L=N/2;
  cc = [cc(end-L+1:end) cc(1:L)];
  dt = [-L+.5:L]*dt0;
end
idx=find(abs(dt)<=t0);
cc=cc(idx); dt=real(dt(idx));
