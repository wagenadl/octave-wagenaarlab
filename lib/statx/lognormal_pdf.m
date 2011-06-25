function y = lognormal_pdf(x,theta,m,sigma)
% y = LOGNORMAL_PDF(x, theta,m,sigma) returns the value of the 
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
y(ok) = exp(-log((x(ok)-theta)/m).^2/(2*sigma^2)) ./ ((x(ok)-theta)*sigma*sqrt(2*pi));
