function pp = cdf_norm(xx,mu,sig)
% CDF_NORM - Cumulative density function for the normal distribution
%   pp = CDF_NORM(xx,mu,sig) returns the cdf for the normal distribution
%   with mean MU and standard deviation SIG at the value(s) XX.

if nargin<2
  mu=0;
end
if nargin<3
  sig=1;
end

pp = .5*erf((xx-mu)/sig/sqrt(2))+.5;

