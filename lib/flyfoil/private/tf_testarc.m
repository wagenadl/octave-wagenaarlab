function [ers, erw] = tf_testarc(xx, yy, xs, ys, phis, phie, R)

xc = xs - R*sin(phis);
yc = ys + R*cos(phis);
N = length(xx);
phi = [0:N-1]'/(N-1)*(phie - phis) + phis;

x = xc + R*sin(phi);
y = yc - R*cos(phi);
err = (xx-x).^2 + (yy-y).^2;
ers = sum(err);
R, phie, ers
if nargout>1
  erw = max(err);
end
