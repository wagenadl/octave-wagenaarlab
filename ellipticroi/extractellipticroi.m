function pxs = extractellipticroi(img,xyxy)
% EXTRACTELLIPTICROI - Get pixels from an ROI
%    pxs = EXTRACTELLIPTICROI(img,xyrra) returns all pixel values 
%    (not just the average) that fall inside the elliptic ROI defined by 
%    XYRRA. This works for single images or stacks of images (shaped YxXxN).
%    See EXTRACTELLIPTICROIS for a way to extract multiple ROIs at once,
%    and EXTRACTSHIFTED for a way to deal with motion artifacts.

xyrra = normellipse(xyxy);

[Y X N]=size(img);

xx = repmat([1:X]-xyrra(1),[Y 1]);
yy = repmat([1:Y]'-xyrra(2),[1 X]);

xi =  xx*cos(xyrra(5))+yy*sin(xyrra(5));
eta = -xx*sin(xyrra(5))+yy*cos(xyrra(5));

in = (xi/xyrra(3)).^2 + (eta/xyrra(4)).^2 < 1;

img = reshape(img,[Y*X N]);

pxs = img(in,:);
