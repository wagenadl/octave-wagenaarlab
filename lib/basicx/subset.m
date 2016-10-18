function x = subset(x, idx)
% SUBSET - Subset of a dataframe
%   y = SUBSET(x, idx), where X is a structure with one or more vector
%   fields, returns that same structure with elements indexed by IDX 
%   preserved from each vector.
%   If X additionally contains nonvectors, or vectors not equal in length
%   to the median length across vectors, those are preserved without
%   subsetting.

len = [];
fld = fieldnames(x);
F = length(fld);
for f=1:F
  S = size(x.(fld{f}));
  if prod(S) == max(S)
    % Non-empty vector
    len(end+1) = max(S);
  end
end
if isempty(len)
  len = 0;
else
  len = median(len);
end

for f=1:F
  S = size(x.(fld{f}));
  if prod(S) == max(S) && max(S)==len
    % Vector of appropriate length!
    x.(fld{f}) = x.(fld{f})(idx);
  end
end
 
 