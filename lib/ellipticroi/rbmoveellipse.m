function xyrra = rbmoveellipse(xyrra,h)
% xyrra = RBMOVEELLIPSE(xyrra,h) allows the user to move an ellipse in the
% specified axes, much like RBBOX.
% XYRRA must be a 5-element vector: (x0,y0,r1,r2,alpha), where
% (x0,y0) is the center of the ellipse, r1, r2 are the major and minor
% radii, and alpha is the angle between the x-axis and r1.
% Drag changes x0, y0, not r1, r2, alpha.

xyrra = normellipse(xyrra); % convert xyxy style to xyrra style

xy = get(h,'currentpoint'); xy=xy(1,1:2)';
f=get(h,'parent');
setappdata(f,'rbmoveellipse_xyrra0',xyrra);
setappdata(f,'rbmoveellipse_xyrra1',xyrra);
setappdata(f,'rbmoveellipse_xy0',xy);
setappdata(f,'rbmoveellipse_axes',h);
set(f,'windowbuttonmotionfcn',@rbme_motion)
set(f,'windowbuttonupfcn',@rbme_up)
rbme_draw(f);
uiwait
xyrra = getappdata(f,'rbmoveellipse_xyrra1');
set(f,'windowbuttonmotionfcn',[]);
set(f,'windowbuttonup',[]);
return

function rbme_draw(f)
a = getappdata(f,'rbmoveellipse_axes');
axes(a);
xyrra = getappdata(f,'rbmoveellipse_xyrra1');
h = plotellipse(xyrra,'color',[1 .5 0],'linew',2);
setappdata(f,'rbmoveellipse_h',h);
return

function rbme_undraw(f)
h = getappdata(f,'rbmoveellipse_h');
delete(h);
return

function rbme_motion(h,x)
f=gcbf;
a=getappdata(f,'rbmoveellipse_axes');
xy0 = getappdata(f,'rbmoveellipse_xy0');
xy1 = get(a,'currentpoint'); xy1=xy1(1,1:2)';
xyrra = getappdata(f,'rbmoveellipse_xyrra0');

xyrra(1:2) = xyrra(1:2) + xy1-xy0;

setappdata(f,'rbmoveellipse_xyrra1',xyrra);

rbme_undraw(f);
rbme_draw(f);
drawnow

return

function rbme_up(h,x)
rbme_motion(h,x)
f=gcbf;
rbme_undraw(f);
uiresume(f);
return
