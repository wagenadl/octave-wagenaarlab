function img = ellipticroi(xyxy,Y,X)
% img = ELLIPTICROI(xyxy,Y,X) creates an YxX sized image with an ellipse
% defined by XYXY in it.
% img = ELLIPTICROI(xyxy,img) adds an ellipse to an existing image
if nargin==3
  img = logical(zeros(Y,X));
else
  img = Y;
end

xyrra = normellipse(xyxy);

[Y X C]=size(img);

xx = repmat([1:X]-xyrra(1),[Y 1]);
yy = repmat([1:Y]'-xyrra(2),[1 X]);

xi =  xx*cos(xyrra(5))+yy*sin(xyrra(5));
eta = -xx*sin(xyrra(5))+yy*cos(xyrra(5));

in = (xi/xyrra(3)).^2 + (eta/xyrra(4)).^2 < 1;

img(in)=1;
