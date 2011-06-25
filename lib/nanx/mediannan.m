function y=mediannan(x,dim)
% y = MEDIANNAN(x) calculates the median of X, ignoring NAN values.
% y = MEDIANNAN(x,dim) operates along dimension DIM.

if nargin<2
  a=size(x);
  dim=findfirst_ge(a,2);
  if dim==0
    dim=1
  end
end

ss=size(x); S=length(ss);
dims=[1:S]; dims(dim)=0; dims=dims(dims>0);
xx = permute(x,[dim dims]);
xx = reshape(xx,[ss(dim) prod(ss(dims))]);
[A B]=size(xx);
yy = zeros(1,B);
for b=1:B
  qq=nonan(xx(:,b));
  if isempty(qq)
    qq=nan;
  end
  yy(b)=median(qq);
end

ss(dim)=1;

y = reshape(yy,ss);
