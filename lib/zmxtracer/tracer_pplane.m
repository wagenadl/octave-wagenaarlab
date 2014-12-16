function [x, f] = tracer_pplane(lens, rev, wavelength)
% TRACER_PPLANE - Location of principal plane in a lens
%   x = TRACER_PPLANE(lens) returns the location of the
%   second principal plane of the given lens relative to the center
%   of the lens.
%   x = TRACER_PPLANE(lens, 1) reverses the lens, so 
%   x = -TRACER_PPLANE(lens, 1) returns the location of the 
%   first principal plane of the unreversed lens.
%   x = TRACER_PPLANE(lens, orient, wavelength) specifies
%   the design wavelength (532 nm is default).
%   [x, f] = TRACER_PPLANE(...) also returns effective focal length
%   of the lens.
%   This works by performing a simple tracing experiment, but it also
%   maintains a temporary database for speed.

if nargin<2
  rev = 0;
end
if nargin<3
  wavelength = 532;
end

global tracer_pplane_db;
name = sprintf('%s:%i:%i', lens.name, wavelength, rev);
if isfield(tracer_pplane_db, name)
  x = tracer_pplane_db.(name).x;
  if nargout>=2
    f = tracer_pplane_db.(name).f;
  end
  return
end

y0 = 0.01;
trc = tracer_construct;
trc = tracer_placeobject(trc, -100, y0, 0);
trc = tracer_addlens(trc, lens, 0, rev, 0);
trc = tracer_trace(trc, wavelength);
f = -y0/trc.tantheta1;
x = trc.xx(end) - f; % Measured from center

tracer_pplane_db.(name).x = x;
tracer_pplane_db.(name).f = f;

if nargout<2
  clear f
end
