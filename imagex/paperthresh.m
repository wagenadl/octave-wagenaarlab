function paperthresh(ifn, ofn)
% PAPERTHRESH - Threshold a webcam image of a photo of a sheet of paper
% PAPERTHRESH(ifn, ofn) loads an image, thresholds it, and saves it.
% PAPERTHRESH(ifn) makes OFN be /tmp/IFN.

if nargin==0
  [fn,fp] = uigetfile('/home/wagenaar/Pictures/Webcam/*.jpg');
  if isempty(fn)
    return;
  end
  ifn = [fp filesep fn];
end


img = imread(ifn);

R = 8;
xx = [-2*R:2*R];
gg = exp(-.5.*xx.^2/R.^2);
gg = gg ./ sum(gg);

img = double(img);
img = mean(img, 3);

lo = convn(convn(img, gg, 'same'), gg', 'same');

hi = img - lo;

imagesc(hi);
colormap(gray);
caxis([-15 -5]);

img = hi+15;
img = img/10;
img(img<0) = 0;
img(img>1) = 1;
imagesc(img);

if nargin<2
  [d,b,e] = fileparts(ifn);
  ofn = sprintf('/tmp/%s%s', b, e);
end
imwrite(img, ofn);
printf('Image saved as %s\n', ofn);