function y = power_lognormal_pdf(x,p,sigma,mu,beta)
% y = POWER_LOGNORMAL_PDF(x,p,sigma,mu,beta) returns the cdf of the 
% Power lognormal pdf at X. 
% Default parameter values: P=1, SIGMA=1, MU=0, BETA=1

if nargin<2
  p=1;
end
if nargin<3
  sigma=1;
end
if nargin<4
  mu=0;
end
if nargin<5
  beta=1;
end

z = (x-mu)/beta;
ok=z>0;
lz=log(z(ok));
y=0*x;
y(ok) = (p./(z(ok)*sigma)) .* normpdf(lz/sigma) .* normcdf(-lz/sigma).^(p-1) / beta;

