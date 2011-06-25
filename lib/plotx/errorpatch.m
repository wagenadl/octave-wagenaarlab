function e=errorpatch(x,y,dy)
% ERRORPATCH   Plot error bars as a patch
%    h = ERRORPATCH(x,y,dy) plots a patch around the curve (X,Y) with local
%    height DY, and returns the plot handle. 
%    The patch is black with transparency 0.5. 
%    This is intended to be used as a graphical replacement for errorbars.
idx=~isnan(x) & ~isnan(y) & ~isnan(dy);
x=x(idx); y=y(idx); dy=dy(idx);
x=x(:); y=y(:); dy=dy(:);
[xx,oo]=sort(x);
yy=y(oo);
dy=dy(oo);
N=length(xx);
e=surf([xx, xx], [yy+dy, yy-dy], zeros(N,2)-2);%,zeros(N*2,1));
set(e,'edgec','none');
set(e,'facealpha',.5);
