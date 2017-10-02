function im1 = uniwhite(img, ofn)
% UNIWHITE - Uniform white background for whiteboard images
%    img = UNIWHITE(img) processes an image
%    UNIWHITE(ifn, ofn) loads and saves an image

if nargin==2
  img = imread(img);
  img = uniwhite(img);
  imwrite(img, ofn);
  return
end

k0 = 200;

[Y X C] = size(img);
R = ceil(max(Y,X)/k0);
N = floor(Y/R);
M = floor(X/R);
img = double(img);
img = reshape(img(1:N*R,1:M*R,:), [R N R M C]);
im1 = permute(img, [1 3 2 4 5]);
im1 = reshape(im1, [R*R N M C]);
thr = median(im1);
im1(im1<thr) = nan;
im1 = meannan(im1);
im1 = reshape(im1, [1 N 1 M C]);
im1 = repmat(im1, [R 1 R 1 1]);
im1 = img./im1;
im1(im1>1) = 1;
im1 = reshape(im1, [N*R M*R C]);
