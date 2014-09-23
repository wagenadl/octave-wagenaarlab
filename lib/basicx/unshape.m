function [cc, S] = unshape(cc)
% UNSHAPE - Convert an arbitrary N-D matrix to Kx3 for color conversion
%   [cc, S] = UNSHAPE(cc) takes an arbitrary N-D matrix and converts it 
%   to a Kx3 matrix and returns the original shape as well so that
%   cc = reshape(cc, S) restores the shape.
%   This assumes that the last non-singleton dimension has size 3.

S = size(cc);
N = prod(S);
cc = reshape(cc, [N/3 3]);

