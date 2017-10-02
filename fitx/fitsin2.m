function [amp,pha,per,err] = fitsin2(tt,yy,amp0,pha0,per0)
% [amp,pha,per] = FITSIN2(tt,yy,amp0,pha0,per0) fits a sine wave to the data

if nargin<3
  amp0 = std(yy);
end
if nargin<4
  pha0=0;
end
if nargin<5
  per0 = (tt(end)-tt(1))/5; % Really arbitrary...
end

[ap,err] = fminsearch(@sinerr,[amp0 pha0 1/per0],[],tt,yy);
amp=ap(1); pha=ap(2); per=1/ap(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function er = sinerr(ap,tt,yy)
amp=ap(1); pha=ap(2); frq=ap(3);
er = sum(yy - amp*sin(tt*2*pi*frq+pha));
