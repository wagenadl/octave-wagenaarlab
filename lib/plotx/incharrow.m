function a = incharrow(p0, p1, l, w, solid)
% a = INCHARROW(p0, p1, l, w, fat) draws an arrow from point P0 to point P1
% in the current graph. 
% The length of the arrowhead is L, measured in inches; the width is W.
% If SOLID is nonzero, a solid head is drawn
% Return: line handles: a(1) = line. a(2) = head.

if nargin<5
  solid=0;
end
if nargin<4
  w=.1;
end
if nargin<3
  l=.1;
end

dx = p1(1)-p0(1);
dy = p1(2)-p0(2);
in = oneinch;
dxin = dx/in(1);
dyin = dy/in(2);
th = atan2(dyin,dxin);

xi = [-1 0 -1]*l;
eta = [-1 0 1]*w;
xx = (xi*cos(th)-eta*sin(th))*in(1) + p1(1);
yy = (xi*sin(th)+eta*cos(th))*in(2) + p1(2);

a(1) = line([p0(1) p1(1)],[p0(2) p1(2)]);
if solid
  a(2) = patch(xx,yy,'b');
  set(a(2),'edgec','none');
else
  a(2) = line(xx,yy);
end
