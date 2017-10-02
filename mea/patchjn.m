function hh = patchjn(cc, varargin)
% PATCHJN - Plots 60 hexagonal patches for JN-style electrode arrays
%   PATCHJN(cc) where CC is 60x3 or 64x3 plots patches in the given colors.
%   PATCHJN(cc, dx, dy) specifies a shift for the output graphics.
%   PATCHJN(cc, dx, dy, scl) also specifies a scale.
%   PATCHJN(..., k, v, ...) specifies additional patch properties.
%   hh = PATCHJN(cc) returns patch handles.
%   You might find APPLYLUT useful.

ish = ishold;

C = size(cc,1);
hh = zeros(C,1);

dx0 = 0;
dy0 = 0;
scl = 1;

if length(varargin)>=2
  if isnscalar(varargin{1})
    dx0 = varargin{1};
    dy0 = varargin{2};
    varargin = varargin(3:end);
  end
end

if length(varargin)>=1
  if isnscalar(varargin{1})
    scl = varargin{1};
    varargin = varargin(2:end);
  end
end

dx = cos([.5:6]*60*pi/180)/sqrt(3);
dy = sin([.5:6]*60*pi/180)/sqrt(3);
for c=1:C
  [x0,y0] = hw2jn(c-1);
  y0 = -(y0-4)*sqrt(3)/2;
  x0 = (x0-8)/2;
  hh(c) = patch(dx0 + scl*(x0+dx), dy0 + scl*(y0+dy), 'c');
  set(hh(c), 'facecolor', cc(c,:), varargin{:});
  hold on
end

if ~ish
  axis([[-8 8]*scl+dx0 [-8 8]*scl+dy0]);
  axis square
  hold off
end

if nargout==0
  clear hh
end
