function a=dpolyarea(x,y)
% DPOLYAREA  Area inside a polygon in 2D space.
%   DPOLYAREA(x,y) calculates the area of the polygon with vertices
%   (x,y).

x=[x(:); x(1)];
y=[y(:); y(1)];
a=0;
N=length(x);
dx1 = x(2:N-1)-x(1);
dx2 = x(3:N)-x(1);
dy1 = y(2:N-1)-y(1);
dy2 = y(3:N)-y(1);

a=sum(dx1.*dy2 - dx2.*dy1)/2;
