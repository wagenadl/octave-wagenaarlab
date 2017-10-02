function [x,y] = idx2xy(S, idx)
% XY2IDX - Convert to coordinates index for an image
%   [x, y] = XY2IDX(size(img), idx) converts an index (as returned, e.g.,
%   by FIND) to (X,Y) coordinates.
%   XY2IDX performs the opposite operation.

y = mod(idx-1,S(1))+1;
x = div(idx-1,S(1))+1;

