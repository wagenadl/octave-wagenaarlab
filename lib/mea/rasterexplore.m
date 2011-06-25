function [p,us]=rasterexplore(tms,chs,use,rnd)
% RASTEREXPLORE(tms,chs,use) produces a raster plot of the times and channels
% given, plotting only those channels mentioned in USE.
% If USE is a scalar, the USE most active channels are selected.
% RASTEREXPLORE(...,rnd) adds random noise of size RND to the plot
% RASTEREXPLORE(rnd) assumes the current graph is the result
% of a RASTEREXPLORE command, and re-assigns random shifts, and drops
% data not currently in view time-wise.
% [p,use] = RASTEREXPLORE(...) returns a plot handle and the set of used
% channels.

if nargin==1
  p=get(gca,'children');
  y=get(p(1),'ydata');
  y=floor(y+.5);
  a=axis;
  axis([a(1) a(2) min(y)-.5 max(y)+.5]);
  x=get(p(1),'xdata');
  idx=find(x>=a(1) & x<=a(2));
  x=x(idx);
  y=y(idx);
  y=y+(rand(size(y))-.5)*tms;
  set(p(1),'xdata',x);
  set(p(1),'ydata',y);
else
  C=length(use);
  
  if C==1
    nn = hist(chs,[0:63]);
    nn(61:end)=0;
    [nn,oo] = sort(-nn);
    use=oo(1:use)-1;
    C=length(use);
  end
  map=zeros(1,64);
  map(use+1) = [1:C];
  chs=map(chs+1);
  idx=find(chs>0);
  if nargin>=4
    chs = chs + (rand(size(chs))-.5)*rnd;
  end
  pp=plot(tms(idx),chs(idx),'k.','markersize',5);
  set(gca,'ytick',[1:C]);
  set(gca,'ytickl',hw2cr(use));
  
  axis([tms(1),tms(end),.5,C+.5]);
  
  if nargout>1
    p=pp;
  end
  if nargin>=2
    us=use;
  end
end