function y=nnan(x,dim)
% y = NNAN(x) calculates the number of non-nan values in columns of X.
% y = NNAN(x,dim) operates along dimension DIM.

if nargin<2
  a=size(x);
  dim=findfirst_ge(a,2);
  if dim==0
    dim=1
  end
end

bad = isnan(x);
s1 = sum(~bad,dim);

y=s1;
