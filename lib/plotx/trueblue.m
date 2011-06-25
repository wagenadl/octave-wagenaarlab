function h = trueblue(x0,dx,yy,avg,over)
% TRUEBLUE - Efficiently plot ephys data without hiding spikes
%    TRUEBLUE(x0,dx,yy) plots the data (x0,yy_1), (x0+dx,yy_2), ...
%    on the current axes, using SAMPLEMINMAX to reduce data length to
%    one point per pixel.
%    TRUEBLUE(x0,dx,yy,1) plots the min and max lines explicitly as well.
%    TRUEBLUE(x0,dx,yy,expl,over) oversamples by a factor OVER.
%    h = TRUEBLUE(...) returns a PATCH handle, and, optionally,
%    two line handles.

if nargin<4
  avg=0;
end
if nargin<5
  over=1;
end

[pw,ph] = axespixsize;
a=axis;
aw=a(2)-a(1);
N=length(yy);
xw=N*dx;
xpw=ceil(over * xw * pw/aw);
ii=1+ceil([0:xpw]/xpw * (N-1));
[ym,yM] = sampleminmax(yy,ii);
ii=ii(1:end-1);

h = patch(x0+dx*[ii fliplr(ii)],[ym fliplr(yM)],'b');
set(h,'edgec','none');
if avg
  h(2)=plot(x0+dx*ii,ym,'b');
  h(3)=plot(x0+dx*ii,yM,'b');
end

if nargout<1
  clear h;
end
