function [amp,pha,err] = fitsin(dat,per,ttt,amp0,pha0)
% [amp,pha,err] = FITSIN(data,period,tms)
% Fits data = amp * sin(2*PI*tms/period + pha).
% Note: the period is kept fixed throughout.

if nargin<4
  amp0=std(dat);
end
if nargin<5
  pha0=0;
end

dat = detrend(dat);
if isempty(ttt)
  ttt=[1:length(dat)]';
end

[ap,err] = fminsearch(@sinerr,[amp0 pha0],[],dat,per,ttt);
err=sqrt(err./length(dat));
amp=ap(1);
pha=ap(2);

if amp<0
  amp=-amp;
  pha=pha+pi;
end

pha=mod(pha,2*pi);
if pha>=pi
  pha=pha-2*pi;
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function chi=sinerr(ap,dat,per,ttt)
amp=ap(1);
pha=ap(2);
sig = amp*sin(ttt*2*pi/per+pha);
chi = sum((sig-dat).^2);
