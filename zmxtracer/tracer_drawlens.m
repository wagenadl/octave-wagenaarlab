function tracer_drawlens(lens, x, rev)
% TRACER_DRAWLENS - Draw a lens onto a QPlot figure
%    TRACER_DRAWLENS(lens, x) draws the LENS at location X.
%    TRACER_DRAWLENS(lens, x, 1) draws the LENS at location X, backwards.

qpen 555 0

if isnumeric(lens)
  qplot([x x], [-1 1]*12.7); % Arbitrarily draw lens as if it has 1" diam
  qat(x, 12.7);
  qalign center bottom
  qtext(0, -5, ifelse(lens>0, '+', '–'));
  return
end

[xx_, rr_, fn_] = tracer_lens2surf(lens, rev);

for k=1:length(xx_)
  x_ = xx_(k) + x;
  r_ = rr_(k);
  if isinf(r_)
    qplot([x_ x_], [-.5 .5]*lens.diam(k));
    xmin(k) = x_;
    xmax(k) = x_;
  else
    yy = [-.5:.1:.5]*lens.diam(k);
    xx = cos(asin(yy/r_))*r_;
    xx = x_ + r_ - xx;
    xmin(k) = xx(1);
    xmax(k) = xx(end);
    qplot(xx, yy);
  end
end
qplot(xmin, -.5*lens.diam);
qplot(xmax, .5*lens.diam);
