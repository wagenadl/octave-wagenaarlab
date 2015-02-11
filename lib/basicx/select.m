function sub = select(mat, idx)
% SELECT - Select cells within a matrix
%    sub = SELECT(mat, idx) where MAT is a matrix and IDX is a column
%    vector of indices, returns a column vector with entries picked 
%    from MAT. Specifically:
%
%        sub(k) = mat(k, idx(k))
%
%    If IDX is a row vector, the output is a row vector:
%
%        sub(k) = mat(idx(k), k)
%
%    In all cases, the length of IDX must match the relevant dimension
%    of MAT, and indices must be non-negative.

[R C] = size(mat);
[RI CI] = size(idx);
if any(~(idx>0))
  error('Array indices must be nonnegative');
end
if CI>1
  if CI~=C
    error('Size mismatch between matrix and index vector');
  elseif any(~(idx<=R))
    error('Indices must not exceed number of rows');
  end
  sub = mat(([1:C]-1)*R+idx);
else
  if RI~=R
    error('Size mismatch between matrix and index vector');
  elseif any(~(idx<=C))
    error('Indices must not exceed number of columns');
  end
  sub = mat((idx-1)*R + [1:R]');
end
