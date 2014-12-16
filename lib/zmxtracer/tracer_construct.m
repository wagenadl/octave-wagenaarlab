function trc = tracer_construct(objx, objyy, objth)
% TRACER_CONSTRUCT - Construct a tracer by placing an object
%    trc = TRACER_CONSTRUCT(objx, objyy, objth) constructs a tracer
%    by placing an object at OBJX along the optical axis,
%    consisting of points at distances OBJYY (a vector) away from 
%    the optical axis, and with rays emanating at angles OBJTH
%    (a vector, specified in radians).

trc.version = '1.0';
trc.placed = 0;
if nargin>0
  trc = tracer_placeobject(trc, objx, objyy, objth);
end
