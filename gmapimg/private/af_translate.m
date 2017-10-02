function xf = af_translate(xf, dx, dy)
% AF_TRANSLATE - Translate a perspective transform
%   xf = AF_TRANSLATE(xf, dx, dy) calculates T_(dx,dy) o XF.

xf = [1 0 dx; 0 1 dy; 0 0 1] * xf;
