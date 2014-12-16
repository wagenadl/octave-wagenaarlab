function tracer_drawobject(x, yy)
% TRACER_DRAWOBJECT - Draws an object or image
%    TRACER_DRAWOBJECT(x, yy) draws the object at position X along the optical
%    axis extending perpendicular to YY (a vector).

qmarker o solid 2
qmark(x + 0*yy, yy);
ym = max(yy);
if ym>0
  qmarker('^', 4);
  qmark(x, ym);
end
ym = min(yy);
if ym<0
  qmarker('v', 4);
  qmark(x, ym);
end
