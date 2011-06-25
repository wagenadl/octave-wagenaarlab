function str = longestcommon(strs)
% LONGESTCOMMON  Longest common substring
%    str = LONGESTCOMMON(strs) returns the longest substring common to
%    all of STRS. (Must match at start.)
if isempty(strs)
  str='';
  return
end

N=length(strs);
str=strs{1};
for n=2:N
  while isempty(strmatch(str,strs{n}))
    str=str(1:end-1);
  end
end
