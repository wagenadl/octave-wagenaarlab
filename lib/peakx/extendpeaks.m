function pkno = extendpeaks(yy,pkpos,thr)
% pkno = EXTENDPEAKS(yy,pkpos,thr) finds areas around the peaks in YY (with
% positions specified by PKPOS) that have YY>=THR.
% Returns a vector matching the length of YY with integer peak numbers
% corresponding to PKPOS.

N=length(pkpos);
pkno=0*yy;
id0=0*pkpos;
id1=0*pkpos;
for n=1:N
  id0(n) = findlast_lt(yy(1:pkpos(n)),thr);
  id1(n) = findfirst_lt(yy(pkpos(n):end),thr);
end
id1=id1+pkpos;
id1(id1==pkpos)=length(yy)+2;
for n=1:N
  pkno(id0(n)+1:id1(n)-2)=n;
end

function mexvsn
% This uses an internal MEX function extendpeaks_core.

if nargin~=3 | prod(size(yy))~=length(yy) | prod(size(pkpos))~=length(pkpos) | prod(size(thr))~=1
  error('Wrong arguments for extendpeaks');
end

yy = double(real(yy));
pkpos = int32(pkpos-1);
thr = double(real(thr));

pkno = extendpeaks_core(yy,pkpos,thr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ep_test
xx=[0:.01:20];
yy=sin(xx);
pkpos=ceil([pi/2:2*pi:20]/.01);
figure(1); clf
plot(xx,yy);
hold on
plot(xx(pkpos),yy(pkpos),'r.');

pkno=extendpeaks(yy,pkpos,.5);

hold on
plot(xx,pkno,'r');
