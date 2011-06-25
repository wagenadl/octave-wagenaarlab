function [dt,cc] = fxcorg(tt,xx,yy)
% [dt,cc] = FXCORG(tt,xx,yy) calculates the crosscorrelation between
% the functions XX=XX(TT) and YY=YY(TT). It is required that TT is
% monotonically increasing and uniformly spaced.
% Positive output DT  corresponds with XX leading YY.

ST=size(tt);
SX=size(xx);
xx=xx(:)';
yy=yy(:)';
dt_ = mean(diff(tt));
N=length(tt);
cc = ifft(conj(fft(xx)).*fft(yy));
if mod(N,2)
  L=N/2-.5;
  cc = [cc(end-L+1:end) cc(1:L+1)];
  dt = [-L:L]*dt_;
else
  L=N/2;
  cc = [cc(end-L+1:end) cc(1:L)];
  dt = [-L+.5:L]*dt_;
end
cc=real(cc);

if ST(1)>1
  dt=dt';
end

if SX(1)>1
  cc=cc';
end
