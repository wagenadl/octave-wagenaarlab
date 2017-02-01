function str = catstr(a, b)
% CATSTR - Concatenate structures with equal members
%   str = CATSTR(str1, str2) concatenates each of the vector elements in
%   STR2 to the end of same name elements in STR1.

fn = fieldnames(a);
fnb = fieldnames(b);
F = length(fn);
if length(fnb) ~= F
  error('CATSTR: fieldname mismatch');
end
for f=1:F
  if ~strcmp(fn{f}, fnb{f})
    error('CATSTR: fieldname mismatch');
  end
end

for f=1:F
  S = size(a.(fn{f}));
  if S(1)>=S(2)
    str.(fn{f}) = [a.(fn{f}); b.(fn{f})];
  else
    str.(fn{f}) = [a.(fn{f}), b.(fn{f})];
  end
end
