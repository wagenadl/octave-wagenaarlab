function trc = tracer_placeobject(trc, objx, objyy, objth)
% TRACER_PLACEOBJECT - Places an object in a tracer
%    trc = TRACER_PLACEOBJECT(objx, objyy, objth) places an
%    object at OBJX along the optical axis, consisting of points 
%    at distances OBJYY (a vector) away from the optical axis,
%    and with rays emanating at angles OBJTH (a vector, specified 
%    in radians).

trc.objx = objx;
trc.objyy = objyy;
trc.objth = objth;
