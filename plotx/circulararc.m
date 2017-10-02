function h = circulararc(x,y,r,phi0, phi1)
% CIRCULARARC2 - Draw a circular arc
%   CIRCLE(x,y,r, phi0,phi1) draws an arc of a circle of radius R centered
%   at (X,Y), running from PHI0 to PHI1 radians.
%   h = CIRCULARARC(...) returns a line handle.

phi=[phi0:2*pi/1e3:phi1];
h = plot(x + r*cos(phi), y + r*sin(phi));

if nargout<1
  clear h
end
