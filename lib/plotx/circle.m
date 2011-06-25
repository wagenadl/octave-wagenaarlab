function h = circle(x,y,r,r1,ang)
% CIRCLE - Draw a circle
%   CIRCLE(x,y,r) draws a circle of radius R centered at (X,Y).
%   CIRCLE(x,y,rx,ry) draws an ellipse.
%   CIRCLE(x,y,rx,ry,angle) draws an ellipse with major axis at the given
%   angle from the x-axis.
%   h = CIRCLE(...) returns a line handle.

if nargin<5
  ang = 0;
end
if nargin<4
  r1 = r;
end
phi=[0:1/1e3:1]*2*pi;
xi = cos(phi)*r;
eta = sin(phi)*r1;
h = plot(x + cos(ang)*xi - sin(ang)*eta, y + sin(ang)*xi + cos(ang)*eta);

if nargout<1
  clear h
end
