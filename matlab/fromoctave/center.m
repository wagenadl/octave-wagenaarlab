function x = center(x, dim)
% CENTER - Subtract mean from a vector or vectors
%    y = CENTER(x) returns X with its mean subtracted.
%    For matrix X, this operates on the first non-singleton dimension.
%    y = CENTER(x, dim) specifies the dimension to operate on.
S = size(x);
if nargin<2
  idx = find(S>1);
  if isempty(idx)
    x = x - x;
    return;
  end
  dim = idx(1);
end

x0 = mean(x, dim);
T = 0*S + 1;
T(dim) = S(dim);
x = x - repmat(x0, T);
