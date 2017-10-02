function  h = circulararc2(x1,y1,x2,y2,r)
% CIRCULARARC2 - Draw a circular arc
%   CIRCULARARC2(x1,y1,x2,y2,r) draws an arc of a circle of radius R going
%   through the points (x1,y1) and (x2,y2).
%   h = CIRCULARARC2(...) returns a line handle.
%   The arc always goes anticlockwise from (X1,Y1) to (X2,Y2), and is 
%   the shorter of the two solutions if R is given positive, or the 
%   longer of the two solutions if R is given negative.

% Let's find the center and start/end angles
% If I model my circle as
%   x = x0 + r*cos(phi),
%   y = y0 + r*sin(phi),
% then I need to find (x0,y0,phi1,phi2) from:
%   x1 = x0 + r*cos(phi1),
%   x2 = x0 + r*cos(phi2),
%   y1 = x0 + r*sin(phi1),
%   y2 = x0 + r*sin(phi2).
% I don't think I can do that. So, try something else.
% If I model my circle using:
%   (x-x0)^2 + (y-y0)^2 = r^2,
% then I should be able to find (x0,y0) by solving
%    (x1-x0)^2 + (y1-y0)^2 = r^2,
%    (x2-x0)^2 + (y2-y0)^2 = r^2.
% Write that out:
%    x1^2 - 2*x1*x0 + x0^2 + y1^2 - 2*y1*y0 + y0^2 - r^2 = 0,
%    x2^2 - 2*x2*x0 + x0^2 + y2^2 - 2*y2*y0 + y0^2 - r^2 = 0.
% Subtract the two:
%    x1^2 - x2^2  - 2*x1*x0 + 2*x2*x0 + y1^2 - y2^2 - 2*y1*y0 + 2*y2*y0 = 0.
% Thus:
%    x0 = (x1^2-x2^2+y1^2-y2^2-2*y1*y0+2*y2*y0) / (2*x1-2*x2)
%       = (x1^2-x2^2+y1^2-y2^2)/(2*x1-2*x2) + (y2-y1)/(x1-x2) * y0.
%       =: a + b*y0.
% Insert that into the first equation above to get:
%    x1^2 - 2*x1*a - 2*x1*b*y0  +  a^2 + 2*a*b*y0 + b^2*y0^2 + y1^2
%                                                 -2*y1*y0 + y0^2 - r^2 = 0.
% This is easily solved as:
%    y0 = (-B +- sqrt(B^2-4*A*C)) / (2*A),
% where:
%   A = b^2+1,
%   B = -2*x1*b + 2*a*b - 2*y1,
%   C = x1^2 - 2*x1*a + a^2 + y1^2 - r^2.
% How do I pick the sign? Let's first find the two solutions:

% I should deal with the x1=x2 case specially.

a = (x1^2-x2^2+y1^2-y2^2)/(2*x1-2*x2);
b = (y2-y1)/(x1-x2);
A = b^2+1;
B = -2*x1*b + 2*a*b - 2*y1;
C = x1^2 - 2*x1*a + a^2 + y1^2 - r^2;

D = sqrt(B^2-4*A*C);
y0a = (-B-D)/(2*A);
y0b = (-B+D)/(2*A);
x0a = a+b*y0a;
x0b = a+b*y0b;

phi1a = atan2(y1-y0a,x1-x0a);
phi2a = atan2(y2-y0a,x2-x0a);
phi1b = atan2(y1-y0b,x1-x0b);
phi2b = atan2(y2-y0b,x2-x0b);

if phi2a<phi1a
  phi2a=phi2a+2*pi;
end

if phi2b<phi1b
  phi2b=phi2b+2*pi;
end


if sign((phi2a-phi1a) - (phi2b-phi1b)) == sign(r)
  phi1 = phi1b;
  phi2 = phi2b;
  x0 = x0b;
  y0 = y0b;
else
  phi1 = phi1a;
  phi2 = phi2a;
  x0 = x0a;
  y0 = y0a;
end

phi=[phi1:2*pi/1e3:phi2];

h = plot(x0 + r*cos(phi), y0 + r*sin(phi));


if nargout<1
  clear h
end
