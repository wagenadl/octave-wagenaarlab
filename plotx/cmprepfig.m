function prepfig(cmwid,wid,hei,h);
if nargin<2 | isempty(wid)
  wid = 6;
end
if nargin<3 | isempty(hei)
  hei = wid/(.5+.5*sqrt(5));
end

if nargin<4
  h=1;
end

hei = (hei/wid) * (cmwid/2.540) * 1.5;
wid = 1 * (cmwid/2.540) * 1.5;

figure(h); clf; axes('position',[0 0 1 1]);

set(gca,'ytick',[]);
set(gca,'xtick',[]);
set(gca,'xcol','w');
set(gca,'ycol','w');
set(gca,'box','off');

%a=axis; x=a(1) + (a(2)-a(1))*-.15; y=a(3) + (a(4)-a(3))*1;
%t=text(x,y,lbl); set(t,'fonts',14); set(t,'fontw','bold');

set(gcf,'inverth','off');set(gcf,'color','w');
set(gcf,'paperu','in');
set(gcf,'paperposition',[1 1 wid hei]);
set(gcf,'renderer','painters');
%set(gcf,'unit','in');
%set(gcf,'position',[15.50-wid 11.00-hei wid hei]);
set(gcf,'unit','pix');
set(gcf,'position',[1550-wid*100 1100-hei*100 wid*100 hei*100]);
%set(gcf,'position',[100 100 75*wid 150*hei]);

hold on