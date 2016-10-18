function x = tracer_imagex(trc)
% TRACER_IMAGEX - X-position of the image of the object
%   x = TRACER_IMAGEX(trc) returns the position along the optical axis
%   of the image of the object in the tracer system TRC according
%   to the most recent call to TRACER_TRACE.
%   The result is the average among the positions of each of the sets of
%   rays emanating from individual object points.

xx = tracer_imagexx(trc);
ok = ~isnan(xx) & ~isinf(xx);
if any(ok)
  x = mean(xx(ok));
else
  x = meannan(xx);
end
