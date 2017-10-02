function xy = fig2ax(xy,h)
% FIG2AX  Convert coordinates from figure to axes
%   xy = FIG2AX(xy,h) converts figure coordinates XY to axes coordinates for
%   axes H.
%
%   NB: This only works if the figure's UNITS property is PIXELS.

f = get(h,'parent');
fig_xywh = get(f,'position');
ax_xywh = get(h,'position');
ax_xx = get(h,'xlim');
ax_yy = get(h,'ylim');

xy(1) = xy(1) / fig_xywh(3);
xy(2) = xy(2) / fig_xywh(4);
xy(1) = (xy(1)-ax_xywh(1)) / ax_xywh(3);
xy(2) = (xy(2)-ax_xywh(2)) / ax_xywh(4);

if strcmp(get(h,'xdir'),'normal')
  ;
else
  ax_xx = ax_xx([2 1]);
end
if strcmp(get(h,'ydir'),'normal')
  ;
else
  ax_yy = ax_yy([2 1]);
end

xy(1) = ax_xx(1) + (ax_xx(2)-ax_xx(1))*xy(1);
xy(2) = ax_yy(1) + (ax_yy(2)-ax_yy(1))*xy(2);
