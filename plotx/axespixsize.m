function [w,h] = axespixsize(h)
% AXESPIXSIZE - Return size of axes in pixels
%    [w,h] = AXESPIXSIZE returns the size of the current axes (gca) in
%    pixels.
%    [w,h] = AXESPIXSIZE(h) returns the size of the given axes.

if nargin<1
  h=gca;
end

u=get(h,'unit');
set(h,'unit','pix');
xywh=get(h,'position');
set(h,'unit',u);

w=xywh(3);
h=xywh(4);
