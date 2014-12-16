function trc = tracer_construct(objx, objyy, objth)
% TRACER_CONSTRUCT - Construct a tracer by placing an object
%    trc = TRACER_CONSTRUCT(objx, objyy, objth) constructs a tracer
%    by placing an object at OBJX along the optical axis,
%    consisting of points at distances OBJYY (a vector) away from 
%    the optical axis, and with rays emanating at angles OBJTH
%    (a vector, specified in radians).

if ~exist('lnull')
  f = which('tracer_construct');
  idx = find(f=='/');
  if isempty(idx)
    p = './';
  else
    p = f(1:idx(end));
  end
  addpath([ p 'lenses']);
  addpath([ p 'glass']);
end

trc.version = '1.0';
trc.placed = 0;
if nargin>0
  trc = tracer_placeobject(trc, objx, objyy, objth);
end
