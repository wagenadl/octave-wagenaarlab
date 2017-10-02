function idx=findlast(x,rel,y)
% FINDLAST - Quickly find a single needle in a haystack
%   idx = FINDLAST(x,'==',y) finds the index of the last entrance
%   in the vector X that equals the scalar Y.
%   idx = FINDLAST(x,rel,y) applies a different relationship test:
%   REL may be one of '==', 'eq'; '!=', '~=', 'ne', '<', 'lt'; '>', 'gt';
%   '<=', 'le'; '>=', 'ge'.
% If not found, returns 0.

if prod(size(x))~=length(x) | prod(size(y))~=1
  error 'findlast must have a vector and a scalar input'
end

switch lower(rel)
  case { '==', 'eq' }
    idx = findlast_eq(x,y);
  case { '!=', '~=', 'ne' }
    idx = findlast_ne(x,y);
  case { '<', 'lt' }
    idx = findlast_lt(x,y);
  case { '>', 'gt' }
    idx = findlast_gt(x,y);
  case { '<=', 'le' }
    idx = findlast_le(x,y);
  case { '>=', 'ge' }
    idx = findlast_ge(x,y);
  otherwise
    idx = 0; 
end

