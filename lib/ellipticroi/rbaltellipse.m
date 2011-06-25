function xyrra = rbaltellipse(xyrra,h,halfsize)
% xyrra = RBALTELLIPSE(xyrra,h) allows the user to change an ellipse in the
% specified axes, much like RBBOX.
% XYRRA must be a 5-element vector: (x0,y0,r1,r2,alpha), where
% (x0,y0) is the center of the ellipse, r1, r2 are the major and minor
% radii, and alpha is the angle between the x-axis and r1.
% By default, drag changes r1, r2, alpha, not x0, y0, but:
% xyrra = RBALTELLIPSE(xyrra,h,1) absorbs half of the change in (x0,y0),
% and the other half in radii/angle.


if nargin<3
  halfsize=0;
end

xyrra = normellipse(xyrra); % convert xyxy style to xyrra style

xy = get(h,'currentpoint'); xy=xy(1,1:2)';
f=get(h,'parent');
setappdata(f,'rbaltellipse_xyrra0',xyrra);
setappdata(f,'rbaltellipse_xyrra1',xyrra);
setappdata(f,'rbaltellipse_xy0',xy);
setappdata(f,'rbaltellipse_axes',h);
setappdata(f,'rbaltellipse_halfsize',halfsize);
set(f,'windowbuttonmotionfcn',@rbae_motion)
set(f,'windowbuttonupfcn',@rbae_up)
rbae_draw(f);
uiwait
xyrra = getappdata(f,'rbaltellipse_xyrra1');
set(f,'windowbuttonmotionfcn',[]);
set(f,'windowbuttonup',[]);
return

function rbae_draw(f)
a = getappdata(f,'rbaltellipse_axes');
axes(a);
xyrra = getappdata(f,'rbaltellipse_xyrra1');
h = plotellipse(xyrra,'color',[1 .5 0],'linew',2);
setappdata(f,'rbaltellipse_h',h);
return

function rbae_undraw(f)
h = getappdata(f,'rbaltellipse_h');
delete(h);
return

function rbae_motion(h,x)
f=gcbf;
a=getappdata(f,'rbaltellipse_axes');
xy0 = getappdata(f,'rbaltellipse_xy0');
xy1 = get(a,'currentpoint'); xy1=xy1(1,1:2)';
xyrra = getappdata(f,'rbaltellipse_xyrra0');

xy0 = xy0 - xyrra(1:2);
xy1 = xy1 - xyrra(1:2);

xi0 =  xy0(1)*cos(xyrra(5)) + xy0(2)*sin(xyrra(5));
eta0 = -xy0(1)*sin(xyrra(5)) + xy0(2)*cos(xyrra(5));
theta0 = atan2(eta0/xyrra(4),xi0/xyrra(3));
rho0 = sqrt((xi0/xyrra(3))^2 + (eta0/xyrra(4))^2);

xi1 =  xy1(1)*cos(xyrra(5)) + xy1(2)*sin(xyrra(5));
eta1 = -xy1(1)*sin(xyrra(5)) + xy1(2)*cos(xyrra(5));
theta1 = atan2(eta1/xyrra(4),xi1/xyrra(3));
rho1 = sqrt((xi1/xyrra(3))^2 + (eta1/xyrra(4))^2);

dalpha = theta1-theta0;
drho = rho1/rho0 - 1;

if getappdata(f,'rbaltellipse_halfsize')
  xyrra(1:2) = xyrra(1:2) + (xy1-xy0)/2;
  drho=drho/2;
  dalpa = dalpha/2;
end

xyrra(5) = xyrra(5) + dalpha;
xyrra(3) = xyrra(3) * (1 + drho*abs(cos(theta0)));
xyrra(4) = xyrra(4) * (1 + drho*abs(sin(theta0)));

setappdata(f,'rbaltellipse_xyrra1',xyrra);

rbae_undraw(f);
rbae_draw(f);
drawnow
return

function rbae_up(h,x)
rbae_motion
f=gcbf;
rbae_undraw(f);
uiresume(f);
return
