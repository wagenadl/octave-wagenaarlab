function paperp(w,h)
% PAPERP(w,h) sets the paperposition and paperorientation for WxH printing.
% This assumes a 8.5"x10.5" printing area.

set(gcf,'paperu','in');

if w>h
  set(gcf,'paperor','landscape');
  set(gcf,'paperp',[.5+(10.5-w)/2,(8.5-h)/2,w,h]);
else
  set(gcf,'paperor','portrait');
  set(gcf,'paperp',[(8.5-w)/2,.5+(10.5-h)/2,w,h]);
end
