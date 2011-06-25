function in = inellipse(xy,xyrra,dr)
% in = INELLIPSE(xy,xyrra) returns 1 if XY lies inside the ellipse XYRRA,
% 0 otherwise.
% in = INELLIPSE(xy,xyrra,dr) adds DR to the ellipse radius before deciding.

if nargin<3
  dr=0;
end

xyrra = normellipse(xyrra);

xx = xy(1) - xyrra(1);
yy = xy(2) - xyrra(2);

xi =  xx*cos(xyrra(5))+yy*sin(xyrra(5));
eta = -xx*sin(xyrra(5))+yy*cos(xyrra(5));

in = (xi/(xyrra(3)+dr)).^2 + (eta/(xyrra(4)+dr)).^2 < 1;
