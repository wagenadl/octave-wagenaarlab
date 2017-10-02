function xywh = elbbox(xyrra)
% ELBBOX - Calculate containing rectangle for an ellipse
%    xywh = ELBBOX(xyrra) calculates a tight rectangular bounding box
%    (leftx,bottomy,width,height) for an ellipse.

el = elbuild_xyrra(xyrra);
[om,yM,ym] = elmaxy(el);
[el.x0,el.y0,el.phi]=identity(el.y0,el.x0,el.phi+pi/2);
[om,xM,xm] = elmaxy(el);
xywh=[xm ym xM-xm yM-ym];
