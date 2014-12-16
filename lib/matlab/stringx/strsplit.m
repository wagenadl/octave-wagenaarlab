function y=strtoks(x,s,needle)
% y = STRTOKS(x) returns a cell array of strings consisting of the
% space delimited parts of X.
% y = STRTOKS(x,s) uses S instead of space.
% y = STRTOKS(...,needle) only returns those tokens that contain NEEDLE
% as a substring.
% If X is already a cell array, it is returned unchanged.

if iscell(x)
  y=x;
  return
end

if nargin<2
  s=sprintf(' \t\n');
end

sep = x==s(1);
for n=2:length(s)
  sep = sep | (x==s(n));
end

[iup, idn] = bschmitt(~sep, 2);
N = length(iup);
y = cell(N, 1);
for n=1:N
  y{n} = x(iup(n):idn(n)-1);
end

if nargin>=3
  z=cell(0,1);
  m=1;
  for n=1:length(y)
    if strfind(y{n},needle)
      z{m}=y{n};
      m=m+1;
    end
  end
  y=z;
end
