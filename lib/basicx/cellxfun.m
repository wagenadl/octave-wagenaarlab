function z = cellxfun(op, x, y)
% CELLXFUN - Like BSXFUN, but accepts cell arguments
%   z = CELLXFUN(op, x, y) calculates Z = OP(X, Y) if X and Y are numeric
%   matrices. Additionally, if X and Y are cell arrays of the same shape, the
%   calculations are performed on each cell, and a cell array is returned.
%   CELLXFUN works recursively if cells in X or Y contain further cell arrays.
%   CELLXFUN also works as expected if X is a cell array but Y is not or 
%   vice versa; the output is a cell array in this case.

if iscell(x)
  N = numel(x);
  z = cell(size(x));
  if iscell(y)
    for n=1:N
      z{n} = cellxfun(op, x{n}, y{n});
    end
  else
    for n=1:N
      z{n} = cellxfun(op, x{n}, y);
    end
  end
else
  if iscell(y)
    N = numel(y);
    z = cell(size(y));
    for n=1:N
      z{n} = cellxfun(op, x, y{n});
    end
  else
    z = bsxfun(op, x, y);
  end
end
