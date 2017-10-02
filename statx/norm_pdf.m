function y = norm_pdf(x,mu,sigma)
% y = NORM_PDF(x) returns the value of the normal pdf at X. 
% y = NORM_PDF(x,mu,sigma) specifies mean and std.dev. of the pdf 
% MU and SIGMA default to 0 and 1.
% Note: X may be any shape.

if nargin<2
  mu=0;
end
if nargin<3
  sigma=1;
end

y = 1/sqrt(2*pi*sigma.^2) * exp(-.5*(x-mu).^2/sigma^2);
