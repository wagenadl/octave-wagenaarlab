function idx = xy2idx(S, x, y)
% XY2IDX - Convert coordinates to index for an image
%   idx = XY2IDX(size(img), x, y) converts (x,y) coordinates to an
%   index (as would be returned by FIND).
%   IDX2XY performs the opposite operation.

idx = y + S(1)*(x-1);
