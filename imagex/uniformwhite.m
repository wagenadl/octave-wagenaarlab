function res = uniformwhite(img, varargin)
% UNIFORMWHITE - Normalize the brightness of an unevenly illuminated image
%    img = UNIFORMWHITE(img) normalizes the image IMG using blocks of
%    size 64x64. White level is the 80th percentile within each block.
%    img = UNIFORMWHITE(img, key, val, ...) specifies more parameters:
%      r - size of block (default: 64)
%      p - percentile (default: 90)
%      w - output white level (default: 0.95)
%      space - color space (default: srgb for YxXxC images, linear for YxX).
%    The output is cropped to even multiples of the block size

kv = getopt('r=64 p=90 w=0.95 space=[]', varargin);

isi = isinteger(img);
if isi
  img = double(img) / 255;
end

[Y X C] = size(img);
R = ceil(kv.r);
NY = floor(Y/R);
NX = floor(X/R);
img = img(1:R*NY, 1:R*NX, :);

if C==3
  if isempty(kv.space)
    kv.space = 'srgb';
  end
end

if C==3 && ~isempty(kv.space)
  img = colorconvert(img, 'from', kv.space, 'to', 'ciexyz');
end

if C>1
  im = mean(img, 3);
else
  im = img;
end

im = reshape(im(1:R*NY, 1:R*NX), [R NY R NX]);
im = permute(im, [1 3 2 4]);
im = reshape(im, [R*R NY NX]);
im = sort(im);
im = squeeze(im(ceil(kv.p*R*R/100), :, :));
g = exp(-.5*[-2:.5:2].^2);
im = convnorm(convnorm(im, g), g');
im = reshape(im, [1 NY 1 NX 1]);
im = repmat(im, [R 1 R 1]);
im = reshape(im, [R*NY R*NX]);
im = repmat(im, [1 1 C]);
res = kv.w .* img./im;

if C==3 && ~isempty(kv.space)
  res = colorconvert(res, 'from', 'ciexyz', 'to', kv.space);
end

if isi
  res = uint8(255*res);
end
