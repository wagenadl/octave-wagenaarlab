function eldr_test
el.x0=1; el.y0=2; el.R=2; el.r=1; el.phi=pi/10;
clf; hold on
h=elplot_xyrra(el,32,'b');
setappdata(gca,'ellipsedata',el);
setappdata(gca,'ellipseh',h);
set([h,gca],'buttondownfcn',@eldr_click)
set(gcf,'position',[500 400 600 600]);
axis([-2 5 -2 5]);

function eldr_click(h,x)
el = getappdata(gca,'ellipsedata');
xy=get(gca,'currentpoint'); xy=xy(1,1:2);
X=xy(1)-el.x0; Y=xy(2)-el.y0;
xi=cos(el.phi)*X+sin(el.phi)*Y;
eta=-sin(el.phi)*X+cos(el.phi)*Y;
dR2=xi^2/el.R^2 + eta^2/el.r^2;
if dR2 < .5^2
  el = eldrag_center(el,32,'r');
else
  but = get(gcf,'selectiontype');
  if strcmp(but,'alt')
    el = eldrag_resize(el,32,'r');
  elseif strcmp(but,'extend')
    el = eldrag_rotate(el,1,32,'r');
  else
    el = eldrag_rotate(el,0,32,'r');
  end
end

setappdata(gca,'ellipsedata',el);
delete(getappdata(gca,'ellipseh'));
h=elplot_xyrra(el,32,'b');
set(h,'buttondownfcn',@eldr_click);
setappdata(gca,'ellipseh',h);
