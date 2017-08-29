function trc = tracer_trace(trc, wl, vec)
% TRACER_TRACE - Applies tracer object
%    trc = TRACER_TRACE(trc, lambda) traces rays emanating from
%    the object contained in TRC. LAMBDA is wavelength in
%    nanometers.
%    XX and YY will be NxYxT where N is the number of surfaces plus 2,
%    Y is the number of points in the object, and T is the number of rays
%    from each point.
%    trc = TRACER_TRACE(trc, lambda, 1) traces one rays from each point;
%    In this case, the OBJTH vector passed to TRACER_CONSTRUCT must be 
%    the same shape as the OBJYY vector.

if nargin<3
  vec = 0;
end

x0 = trc.objx;
if ~trc.placed
  trc = tracer_placelenses(trc, wl);
end

if vec
  for y=1:length(trc.objyy)
    [xx(:,y), yy(:,y), y1(y), tantheta1(y)] = ...
	tracer_sphereray(trc.objx, trc.objyy(y), trc.objth(y), ...
	trc.x_surf, trc.r_surf, trc.dn_surf);
  end
else
  for y=1:length(trc.objyy)
    for t=1:length(trc.objth)
      [xx(:,y,t), yy(:,y,t), y1(y,t), tantheta1(y,t)] = ...
	  tracer_sphereray(trc.objx, trc.objyy(y), trc.objth(t), ...
	  trc.x_surf, trc.r_surf, trc.dn_surf);
    end
  end
end

trc.xx = xx;
trc.yy = yy;
trc.y1 = y1;
trc.tantheta1 = tantheta1;
