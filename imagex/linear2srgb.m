function img = linear2srgb(img)
% LINEAR2SRGB - Convert linear grayscale or RGB image to sRGB
%   rgb = LINEAR2SRGB(lin) takes a linear gray scale image or RGB image
%   and converts it to sRGB color space by applying the appropriate gamma
%   curve. LIN may be any shape; RGB will be the same shape.
%   LIN must be in the domain [0, 1]; RGB will be in the same range.
%
%   The curve is: RGB = 12.92 LIN for LIN < 0.00313
%                     = 1.055 LIN^(1/2.4) - 0.055 otherwise
%
%   See also SRGB2LINEAR.

% Formula taken from Wikipedia: http://en.wikipedia.org/wiki/SRGB.

img(img<0) = 0;
img(img>1) = 1;

lin = img<0.0031308;

img(lin) = 12.92*img(lin);
img(~lin) = 1.055*img(~lin).^(1/2.4) - 0.055;
