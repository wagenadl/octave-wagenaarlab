function img = gmi_roiimg(rois, X, Y)
img = ones(Y, X);
xx = [1:X];
yy = [1:Y]';
N = length(rois.x);
for n=1:N
  ins = (xx-rois.x(n)).^2./rois.rx(n).^2 + (yy-rois.y(n)).^2./rois.ry(n).^2 < 1;
  img(ins) *= 0.5;
end

img = 1-img;
gg = exp(-.5*[-2:2].^2/1.5^2);
gg = gg ./ sum(gg);
img = convn(img, gg, 'same');
img = convn(img, gg', 'same');
