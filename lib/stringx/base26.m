function str=base26(n,forcecell)
% BASE26 - Return a string representation in base 26 using lowercase.
%    str = BASE26(n) returns a string representation of the positive
%    integer N in base 26, s.t. 1='a', 26='z', 27='aa', 52='az', etc.
%    The output is a simple string if N is a scalar, or a cell array
%    of strings if N is a matrix.
%    str = BASE26(n,1) returns a cell array even for scalar N.

if nargin<2
  forcecell=0;
end

if forcecell || prod(size(n))>1
  [K L]=size(n);
  str = cell(K,L);
  for k=1:K
    for l=1:L
      str{k,l} = base26(n(k,l));
    end
  end
else
  if n<1
    str='-';
    return
  end
  str='';
  n=n-1;
  ok=1;
  while ok
    if n<=26 && ~isempty(str)
      str=['`'+n str];
      ok=0;
    else
      str=['a'+mod(n,26)  str];
      ok=n>=26;
      n=div(n,26);
    end
  end
end
str=char(str);
