function [xx, yy] = tracer_rays(trc)
% TRACER_RAYS - Retrieve rays from most recent trace
%    [xx, yy] = TRACER_RAYS(trc) returns rays from the most recent
%    call to TRACER_TRACE.
%    XX and YY will be NxYxT where N is the number of surfaces plus 2,
%    Y is the number of points in the object, and T is the number of rays
%    from each point.

xx = trc.xx;
yy = trc.yy;
