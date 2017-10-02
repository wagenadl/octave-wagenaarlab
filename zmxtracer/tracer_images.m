function [y, sy] = tracer_images(trc, x)
% TRACER_IMAGES - Position and spread of the images of object points
%   [y, sy] = TRACER_IMAGES(trc) returns the positions and spreads
%   perpendicular to the optical axis of the images of each of the points
%   in the object according to the most recent call to TRACER_TRACE.
%   [y, sy] = TRACER_GETIMAGES(trc, x) instead specified a specific point
%   along the optical axis.

if nargin<2
  x = tracer_imagex(trc);
end

yy = trc.y1 + trc.tantheta1.*x;
y = mean(yy, 2);
sy = std(yy, [], 2);
