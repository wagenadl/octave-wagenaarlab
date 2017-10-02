function h=plotellipse(xyrra,varargin)
% h = PLOTELLIPSE(xyrra) plots an ellipse specified by XYRRA in the current
% axes and returns a handle.
% h = PLOTELLIPSE(xyrra,...) passes additional arguments on to PLOT.

xyrra = normellipse(xyrra);

r = sqrt(xyrra(3)^2 + xyrra(4)^2);
theta = [0:1/(r+2)^.7:pi*2];
xi = xyrra(3)*cos(theta);
eta = xyrra(4)*sin(theta);
x = xi*cos(xyrra(5))-eta*sin(xyrra(5)) + xyrra(1);
y = xi*sin(xyrra(5))+eta*cos(xyrra(5)) + xyrra(2);
h = plot(x,y,varargin{:});
