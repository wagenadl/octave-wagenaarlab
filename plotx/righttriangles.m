function p=righttriangles(x,y,dx,dy)
% p = RIGHTTRIANGLES(x,y,d) plots a set of filled righttriangles centered at
% (X,Y), and with diameters D, and returns a vector of plot
% handles. 
% p = RIGHTTRIANGLES(x,y,dx,dy) plots a set of filled righttriangles centered at
% (X,Y), and with diameters (DX,DY).
if nargin<4
  dy=dx;
end
p=zeros(size(x))+nan;
dx=0*x+dx/sqrt(6); dy=0*y+dy/sqrt(6);
y0 = y-dy*sqrt(3);
y1 = y+dy*sqrt(3);
x0 = x-dx;
x1 = x+2*dx;
for k=1:length(x)
  if ~isnan(x(k)+y(k))
    p(k)=patch([x0(k) x0(k) x1(k)],[y0(k) y1(k) y(k)],'k');
    hold on
  end
end
p=p(~isnan(p));
