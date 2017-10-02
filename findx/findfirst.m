function idx=findfirst(x,rel,y)
% FINDFIRST - Quickly find a single needle in a haystack
%   idx = FINDFIRST(x,'==',y) finds the index of the first entrance
%   in the vector X that equals the scalar Y.
%   idx = FINDFIRST(x,rel,y) applies a different relationship test:
%   REL may be one of '==', 'eq'; '!=', '~=', 'ne', '<', 'lt'; '>', 'gt';
%   '<=', 'le'; '>=', 'ge'.
% If not found, returns 0.

if prod(size(x))~=length(x) | prod(size(y))~=1
  error 'findfirst must have a vector and a scalar input'
end

switch lower(rel)
  case {'==', 'eq'}
    idx = findfirst_eq(x,y);
  case {'!=', '~=', 'ne'}
    idx = findfirst_ne(x,y);
  case {'<','lt'}
    idx = findfirst_lt(x,y);
  case {'>','gt'}
    idx = findfirst_gt(x,y);
  case {'<=','le'}
    idx = findfirst_le(x,y);
  case {'>=','ge'}
    idx = findfirst_ge(x,y);
  otherwise
    idx = 0;
end

