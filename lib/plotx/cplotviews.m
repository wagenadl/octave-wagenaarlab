function [pp,l] = cplotviews(dat,xdim,ydim,cc)
% p = CPLOTVIEWS(dat,xdim,ydim,clr) is a direct cross between PLOTVIEWS
% and CPLOT.
% [p,l] = CPLOTVIEW(...) plots grey separators.

if nargout>=2
  [dum,l] = plotviews(dat(:,[]),xdim,ydim);
end

C=size(cc,1);
[D,N]=size(dat);

h=ishold;
pp=zeros(C,1)+nan;
for c=1:C
  t0=ceil((c-1)/C*N+.0000001);
  t1=floor(c/C*N);
  if t1>t0
    pp(c)=plotviews(dat(:,t0:t1),xdim,ydim);
    set(pp(c),'color',cc(c,:));
  end
  hold on
end

if ~h
  hold off
end

pp=pp(~isnan(pp));

if nargin<1
  clear pp
end
