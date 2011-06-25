function y = lognormal_cdf(x,theta,m,sigma)
% y = LOGNORMAL_CDF(x, theta,m,sigma) returns the cdf of the 
% lognormal pdf at X. 
% Default parameter values: THETA=0, M=1, SIGMA=1



if nargin<2
  theta=0;
end
if nargin<3
  m=1;
end
if nargin<4
  sigma=1;
end

ok=x>theta;
y=0*x;
y(ok) = normcdf(log((x(ok)-theta)/m)/sigma);
