function prepfig(wid,hei,h);
% PREPFIG(wid,hei) creates a figure of WIDxHEI inches
% PREPFIG(wid,-rat) creates a figure of given width, and aspect ratio 
% PREPFIG(-rat,hei) creates a figure of given height, and aspect ratio 
% PREPFIG(wid) creates a figure of given width and aspect ratio 1.62:1
% PREPFIG(...,h) creates the figure with number H.

if nargin<1
  wid=[];
end
if isempty(wid)
  wid = 6;
end
if nargin<2
  hei = [];
end
if isempty(hei)
  hei = wid/(.5+.5*sqrt(5));
end

if nargin<3
  h=1;
end

if wid<0
  wid=-hei*wid;
end
if hei<0
  hei=-wid*hei;
end

try
  xywh=get(h, 'position');
  close(h);
catch
  xywh = get(0,'screensize');
  xywh = [xywh(3)-50-wid*100 xywh(4)-100-hei*100];
end

figure(h);
set(h, 'position', [xywh(1) xywh(2) wid*100 hei*100]);
axes('position',[0 0 1 1]);
axis off

set(gcf,'inverthardcopy','off');
set(gcf,'color','w');

set(gcf,'paperunits','inches');
wh = get(gcf,'papersize');
set(gcf,'paperposition',[wh(1)/2-wid/2 wh(2)/2-hei/2 wid hei]);

hold on
