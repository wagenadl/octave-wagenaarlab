function img=elfill(Y,X,el,smo_r)
% ELFILL  Fill an ellipse
%    img = ELFILL(Y,X,el) creates an image of size YxX, with pixels
%    inside the ellipse defined by EL set to logical one, others to zero.
%    EL must specify an ellipse in radii and angle representation. 
%    See ELABC2RRA for information about ellipse representations.

% This function is optimized by only performing computation on a 
% subset of the image for which
%
%   |x-x0| <= max(el.R,el.r)   and   |y-y0| <= max(el.R,el.r).

r = max(el.R,el.r);
x0 = max(floor(el.x0-r),1);
x1 = min(ceil(el.x0+r),X);
y0 = max(floor(el.y0-r),1);
y1 = min(ceil(el.y0+r),Y);

X_ = 1+x1-x0;
Y_ = 1+y1-y0;

xx = repmat([x0:x1],[Y_ 1]) - el.x0;
yy = repmat([y0:y1]',[1 X_]) - el.y0;

xi = cos(el.phi)*xx + sin(el.phi)*yy;
eta = -sin(el.phi)*xx + cos(el.phi)*yy;

if nargin<4
  img = logical(zeros(Y,X));
  img(y0:y1,x0:x1) = xi.^2/el.R^2 + eta.^2/el.r^2 <= 1;
else
  r0 =  (xi.^2/el.R^2 + eta.^2/el.r^2 - 1) * sqrt(el.R^2+el.r^2);
  img = zeros(Y,X);
  img(y0:y1,x0:x1) = .5-.5*tanh(r0/smo_r);
end

