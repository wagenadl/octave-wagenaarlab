function qpatchjn(cc, dx0, dy0, scl)
% QPATCHJN - Plots 60 hexagonal patches for JN-style electrode arrays
%   QPATCHJN(cc) where CC is 60x3 or 64x3 plots patches in the given colors.
%   QPATCHJN(cc, dx, dy) specifies a shift for the output graphics.
%   QPATCHJN(cc, dx, dy, scl) also specifies a scale.
%   You might find APPLYLUT useful.

C = size(cc,1);

if nargin<2
  dx0=0;
end
if nargin<3
  dy0=0;
end
if nargin<4
  scl=1;
end

dx = cos([.5:6]*60*pi/180)/sqrt(3);
dy = sin([.5:6]*60*pi/180)/sqrt(3);

for c=1:C
  [x0,y0] = hw2jn(c-1);
  y0 = -(y0-4)*sqrt(3)/2;
  x0 = (x0-8)/2;
  qbrush(cc(c,:));
  qpatch(dx0 + scl*(x0+dx), dy0 + scl*(y0+dy));
end
