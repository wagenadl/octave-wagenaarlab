function tracer_drawsystem(trc, xend)
% TRACER_DRAWSYSTEM - Draws optical axis, lenses, and object
%    TRACER_DRAWSYSTEM(trc) draws an optical axis for the tracer
%    system TRC; the lenses; the object; and little
%    markers at all focal planes and image planes
%    TRACER_DRAWSYSTEM(trc, xend) specifies a maximum x position.

K = length(trc.lenses);
if ~trc.placed
  trc = tracer_placelenses(trc);
end
if nargin<2
  xend = tracer_imagex(trc);
end

% Find positions of lenses so we can draw axis
xx = [trc.objx, xend, min(trc.x_surf)];
xx(isinf(xx)) = 100*sign(xx(isinf(xx))); % Or something.
x0 = min(xx);
x1 = max(xx);

% Draw optical axis
qpen 777 0
qplot([x0 x1], [0 0]);

% Draw lenses
for k=1:K
  tracer_drawlens(trc.lenses{k}, trc.xlens1(k), trc.flip(k));
end

% Draw conjugate planes
qmarker '+' 3
for k=1:K
%  qmark(trc.xlens{k} + [-1 0 1]*trc.lenses{k}.f, [0 0 0]);
end

% Draw object
x = trc.objx;
yy = trc.objyy;
qpen k 0
if isinf(x)
  for k=1:length(yy)
    qplot([-100 -50], yy(k)+[0 0]);
  end
else
  qplot(x + 0*yy, yy);
  tracer_drawobject(x, yy);
end