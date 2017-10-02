function pp = pdf_norm(xx,mu,sig)
% PDF_NORM - Probability density function for the normal distribution
%   pp = PDF_NORM(xx,mu,sig) returns the pdf for the normal distribution
%   with mean MU and standard deviation SIG at the value(s) XX.

if nargin<2
  mu=0;
end
if nargin<3
  sig=1;
end

pp = 1/sqrt(2*pi)/sig * exp(-.5*(xx-mu).^2/sig^2);

