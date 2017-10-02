function str = mergestruct(a, b)
% MERGESTRUCT - Merge fields from two structures
%    str = MERGESTRUCT(a, b) where A and B are structures, makes STR be a
%    structure that contains all the fields of both A and B. 
%    If A and B contain a field with the same name, the contents of B override
%    the contents of A.
%    Inspired by MERGESTRUCTS from David Brown's and Alon Greenbaum's code.

str = a;

fn = fieldnames(b);
F = length(fn);

for f=1:F
  str.(fn{f}) = b.(fn{f});
end

