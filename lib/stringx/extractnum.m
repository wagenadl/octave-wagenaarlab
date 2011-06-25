function nums = extractnum(str,sep)
% nums = EXTRACTNUM(str) returns a vector of numbers extracted from STR.
% STR will usually be a filename, with parts separated by one of "/-._".
% This returns all numeric parts from STR, simply skipping others.
% nums = EXTRACTNUM(str,sep) specifies the set of separator characters.
% E.g.: Use SEP = "/_" to allow signed real numbers.

if nargin<2
  sep = '/-._';
end

parts = strtoks(str,sep); P=length(parts);

nums=[];

for p=1:P
  n = str2double(parts{p});
  if ~isnan(n)
    nums = [ nums, n ];
  end
end
