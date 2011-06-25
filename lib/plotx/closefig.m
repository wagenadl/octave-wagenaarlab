function closefig(dir,fn);
if nargin==1
  fn = dir;
else
  fn = [ dir filesep fn ];
end
%if nargin<2 | isempty(wid)
%  wid = 6;
%end
%if nargin<3 | isempty(hei)
%  hei = wid/(.5+.5*sqrt(5));
%end
%
%set(gca,'ytick',[]);
%set(gca,'xtick',[]);
%set(gca,'xcol','w');
%set(gca,'ycol','w');
%set(gca,'box','off');
%
%%a=axis; x=a(1) + (a(2)-a(1))*-.15; y=a(3) + (a(4)-a(3))*1;
%%t=text(x,y,lbl); set(t,'fonts',14); set(t,'fontw','bold');
%
%set(gcf,'inverth','off');set(gcf,'color','w');
%set(gcf,'paperu','in');
%set(gcf,'paperposition',[1 1 wid hei]);
%set(gcf,'renderer','painters');
print('-depsc2', [ basename(fn,'.eps') '.eps' ]);
