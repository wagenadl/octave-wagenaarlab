function n = unbase26(str)
% UNBASE26 - Convert a base-26 string representation to integer
%   n = UNBASE26(str) performs the reverse operation of BASE26.

if iscell(str)
  [K L]=size(str);
  n=zeros(K,L);
  for k=1:K
    for l=1:L
      n(k,l) = unbase26(str{k,l});
    end
  end
else
  n=0;
  Q=length(str);
  for q=1:Q
    if q<Q & q==1
      n=str(q)-'`';
    else
      n=26*n+(str(q)-'a');
    end
  end
  n=n+1;
end
