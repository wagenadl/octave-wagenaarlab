function hiddenaxes(x,y,w,h)
% HIDDENAXES(x,y,w,h)

axes('position',[x,y,w,h]);

set(gca,'ytick',[]);
set(gca,'xtick',[]);
set(gca,'xcol','w');
set(gca,'ycol','w');
set(gca,'box','off');

hold on
