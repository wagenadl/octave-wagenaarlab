function x = tracer_conjugatex(trc)
% TRACER_CONJUGATEX - X-position of the conjugate image of object
%   x = TRACER_CONJUGATEX(trc) returns the position along the optical axis
%   of the conjugate image of the object in the tracer system TRC according 
%   to the most recent call to TRACER_TRACE. 
%   The result is the average among the positions of each of the sets of
%   parallel rays.

xx = tracer_conjugatexx(trc);
ok = ~isnan(xx) & ~isinf(xx);
if any(ok)
  x = mean(xx(ok));
else
  x = meannan(xx);
end
