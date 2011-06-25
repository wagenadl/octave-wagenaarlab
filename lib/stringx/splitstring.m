function y = splitstring(x,s,dropempty)
% SPLITSTRING  Split a string into parts
%    cel = SPLITSTRING(str,delim) splits the string STR into parts 
%    delimited by occurrences of DELIM, which must be a single character.
%    Empty parts are returned, unless called as SPLITSTIRNG(str,delim,1).

if nargin<3
  dropempty=0;
end
idx = find(x==s); N=length(idx);
y=cell(0,1);
idx = [0 idx length(x)+1];
for n=1:N+1
  if idx(n+1)>idx(n)+1 | ~dropempty
    y{end+1} = x(idx(n)+1:idx(n+1)-1);
  end
end

