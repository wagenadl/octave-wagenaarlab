function y=meannan(x,dim)
% y = MEANNAN(x) calculates the mean of X, ignoring NAN values.
% y = MEANNAN(x,dim) operates along dimension DIM.

if nargin<2
  a=size(x);
  dims=find(a>=2);
  if isempty(dims)
    dim=1;
  else
    dim=dims(1);
  end
end

if isempty(x)
  y=nan;
  return
end

bad = isnan(x);
x(bad)=0;
s1 = sum(~bad, dim);
sx = sum(x, dim);
if s1==0 && sx==0
  y = nan;
else
  y = sx ./ s1;
end
