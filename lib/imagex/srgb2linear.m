function img = srgb2linear(img)
% SRGB2LINEAR - Convert sRGB image to linear
%    LIN = SRGB2LINEAR(RGB) performs the inverse operation to LINEAR2SRGB.

img(img<0) = 0;
img(img>1) = 1;

lin = img< 0.04045;

img(lin) = img(lin) / 12.92;
img(~lin) = ((img(~lin)+0.055)/1.055) .^ 2.4;
