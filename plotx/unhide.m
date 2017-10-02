function unhide(ff)
% UNHIDE - Pull figures away from hiding
%   This is necessary on my dual monitor setup, because the desktop measures
%   3840x1920, but not all of that space is actually visible on a monitor.
if nargin==0 || isempty(ff)
  ff = get(0, 'children');
end

for f = ff(:)'
  xywh = get(f, 'position');
  x = xywh(1);
  y = xywh(2);
  w = xywh(3);
  h = xywh(4);
  if x+w/2 < 1920
    if y+h > 1200
      set(f, 'position', [x 1200-h w h]);
    elseif y < 200
      set(f, 'position', [x 200 w h]);
    end
  end
end
