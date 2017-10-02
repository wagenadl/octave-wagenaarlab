function img = tiffomap(img,pp)
% TIFFOMAP - Maps an image to the color space of an other image
%   img = TIFFOMAP(img,pp) uses the output of TIFFOSTAT to map an image 
%   to the color space of another image.
%   This operates in RGB space, assuming the images are in that space.
%   It is worth considering transforming to hsv space first.

img = double(img);
for c=1:3
  img(:,:,c) = pp(1,c)*img(:,:,c).^2 + pp(2,c)*img(:,:,c) + pp(3,c);
end
img(img<0)=0;
img(img>255)=255;
