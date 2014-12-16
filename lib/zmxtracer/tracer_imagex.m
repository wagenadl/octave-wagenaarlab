function x = tracer_imagex(trc)
% TRACER_IMAGEX - X-position of the image of the first object point
%   x = TRACER_IMAGEX(trc) returns the position along the optical axis
%   of the image of the first point in the tracer system TRC according
%   to the most recent call to TRACER_TRACE.

[N Y T] = size(trc.xx);
for y=1:Y
  xx = trc.xx(end,y,:);
  ok = ~isinf(xx) & ~isnan(xx);
  if any(ok)
    x = mean(xx(ok));
    return;
  end
end

for y=1:Y
  xx = trc.xx(end,y,:);
  ok = ~isnan(xx);
  if any(ok)
    x = mean(xx(ok));
    return;
  end
end

x = nan;
