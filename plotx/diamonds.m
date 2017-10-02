function p=diamonds(x,y,dx,dy)
% p = diamonds(x,y,dx,dy) plots a set of filled diamonds centered at
% (X,Y), and with sizes (DX,DY), and returns a vector of plot handles.
if nargin<4
  dy=dx;
end
p=zeros(size(x))+nan;
dx=0*x+dx/sqrt(2);
dy=0*y+dy/sqrt(2);
for k=1:length(x);
  if ~isnan(x(k)+dx(k)+y(k)+dy(k))
    p(k)=patch(x(k)+dx(k)*[-1 0 1 0],y(k)+dy(k)*[0 -1 0 1],'k');
  end
  hold on
end
p=p(~isnan(p));
