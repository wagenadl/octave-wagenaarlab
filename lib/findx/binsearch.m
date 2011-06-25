function idx = binsearch(xx,y)
% BINSEARCH - Binary search for value in sorted vectors
%    idx = BINSEARCH(xx,y), where XX is a pre-sorted real-valued vector,
%    and Y is a real scalar, returns IDX such that XX(k)<Y for all k<IDX,
%    and XX(k)>=Y for all k>=IDX.
%    Unlike standard binary search, this function does not care whether
%    the value Y actually occurs in XX. If Y does occur in XX, the result
%    will always point to the first occurrence.
%    Thus, if XX(k)>=Y for all k, it will return 1, while if XX(k)<Y for
%    all k, it will return length(xx)+1. (Thus, if XX is empty, the return
%    will always be 1.)

if isempty(xx)
  idx=1;
  return
end

S=size(xx);
if iscell(xx) | prod(S)~=max(S) | ~isreal(xx)
  error('BINSEARCH only works on real vectors xx')
end
if ~isreal(y) | prod(size(y))~=1
  error('BINSEARCH only works on real scalars y')
end

idx = binsearch_core(xx(:),y) + 1;
