function p=uptriangles(x,y,dx,dy)
% p = UPTRIANGLES(x,y,d) plots a set of filled uptriangles centered at
% (X,Y), and with diameters D, and returns a vector of plot
% handles. 
% p = UPTRIANGLES(x,y,dx,dy) plots a set of filled uptriangles centered at
% (X,Y), and with diameters (DX,DY).
if nargin<4
  dy=dx;
end
p=zeros(size(x))+nan;
dx=0*x+dx/sqrt(6); dy=0*y+dy/sqrt(6);
x0 = x-dx*sqrt(3);
x1 = x+dx*sqrt(3);
y0 = y-dy;
y1 = y+2*dy;
for k=1:length(x)
  if ~isnan(x(k)+y(k))
    p(k)=patch([x0(k) x1(k) x(k)],[y0(k) y0(k) y1(k)],'k');
    hold on
  end
end
p=p(~isnan(p));
