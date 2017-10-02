function y=fractile(xx,p)
% y = FRACTILE(xx,p) returns the p-th fractile of xx.
% Note: P must range 0-1, not 0-100 as for a fractile!
% This is done by interpolating linearly between two nearest data points.

N=length(xx);
if N==0
  y = nan;
  return
end
n=p*N;
n0 = max([1 floor(n)]);
n1 = ceil(n);
dn = max([0, n-n0]);

zz = sort(xx);

y = zz(n0)*(1-dn) + zz(n1)*dn;

