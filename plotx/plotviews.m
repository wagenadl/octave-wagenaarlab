function [p,l]=plotviews(dat,xdim,ydim)
% p = PLOTVIEWS(dat,xdim,ydim) plots the data DAT in multiple views, defined
% by XDIM and YDIM, which must both be RxC sized.
% Each view has extent (0,1)x(0,1).
% Data is plotted as blue points, but a plot handle is returned, so you can
% change that.
% DAT must be DxN.
% [p,l] = PLOTVIEWS(...) plots grey lines to separate plots.

[R,C] = size(xdim); 
[D,N] = size(dat);

xx=[];
yy=[];
for c=1:C
  for r=1:R
    if xdim(r,c) & ydim(r,c)
      x_ = dat(xdim(r,c),:);
      y_ = dat(ydim(r,c),:);
      idx = find(x_>0 & x_<1 & y_>0 & y_<1);
      xx=[xx x_(idx)+(c-1) nan];
      yy=[yy y_(idx)+(R-r) nan];
    end
  end
end

if nargout>1
  clf
  for c=1:C-1
    l(c)=line([c c],[0 R]); set(l,'color',[.7 .7 .7]);
  end
  for r=1:R-1
    l(c+C-1)=line([0 C],[r r]); set(l,'color',[.7 .7 .7]);
  end
  hold on
end

p=plot(xx,yy,'.');
axis([0 C 0 R]);

if nargout==0
  clear p
end
