function [d,theta] = disttoellipse(xy,xyrra)
% d = DISTTOELLIPSE(xy,xyrra) returns the distance between XY and the 
% nearest point on ellipse XYRRA.
% NB: This is not fast!
% [d, theta] = DISTTOELLIPSE(xy,xyrra) also returns corresponding angle.

xyrra = normellipse(xyrra);

xx = xy(1) - xyrra(1);
yy = xy(2) - xyrra(2);

xi =  xx*cos(xyrra(5))+yy*sin(xyrra(5));
eta = -xx*sin(xyrra(5))+yy*cos(xyrra(5));

%[theta,d] = fminsearch(@(theta) dte_dist(theta,xi,eta,xyrra),0);

[theta,d] = fminsearch(@dte_dist,0,[],xi,eta,xyrra);

d = sqrt(d);
return

function d = dte_dist(theta,xi,eta,xyrra)
xi_ = xyrra(3)*cos(theta);
eta_ = xyrra(4)*sin(theta);
d = (xi_-xi).^2 + (eta_-eta).^2;
return
