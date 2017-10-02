function y=sumnan(x,dim)
% y = SUMNAN(x) calculates the sum of X, ignoring NAN values.
% y = SUMNAN(x,dim) operates along dimension DIM.

if nargin<2
  a=size(x);
  dim=findfirst_ge(a,2);
  if dim==0
    dim=1
  end
end

bad = isnan(x);
x(bad)=0;
%s1 = sum(~bad,dim);
sx = sum(x,dim);
y = sx;% ./ s1;
