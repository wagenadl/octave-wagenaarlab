function p=squares(x,y,dx,dy)
% p = SQUARES(x,y,d) plots a set of filled squares centered at
% (X,Y), and with diameters D, and returns a vector of plot
% handles. 
% p = SQUARES(x,y,dx,dy) plots a set of filled rectangles centered at
% (X,Y), and with diameters (DX,DY).
if nargin<4
  dy=dx;
end
p=zeros(size(x))+nan;
dx=0*x+dx; dy=0*y+dy;
x=x-dx/2; y=y-dy/2;
for k=1:length(x);
  pos = [x(k) y(k) dx(k) dy(k)];
  if ~isnan(sum(pos))
    p(k)=rectangle('position',pos);
    hold on
  end
end
p=p(~isnan(p));
set(p,'facec','k');
set(p,'edgec','k');
