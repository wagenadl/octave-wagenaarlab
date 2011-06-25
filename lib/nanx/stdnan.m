function y=stdnan(x,flag,dim)
% y = STDNAN(x) calculates the stddev of X, ignoring NAN values.
% y = STDNAN(x,1) normalizes by N instead of N-1.
% y = STDNAN(x,flag,dim) operates along dimension DIM.

if nargin<2
  flag=0;
end
if nargin<3
  a=size(x);
  dim=findfirst_ge(a,2);
  if dim==0
    dim=1;
  end
end
if isempty(flag)
  flag=0;
end

if isempty(x)
  y=nan;
  return
end

bad = isnan(x);
x(bad)=0;
s1 = sum(~bad,dim);
sx = sum(x,dim);
sxx = sum(x.*x,dim);
y = sxx - sx.*sx./s1;
if flag
  y = y ./ s1;
else
  y = y ./ (s1-1);
end
y=sqrt(y);


