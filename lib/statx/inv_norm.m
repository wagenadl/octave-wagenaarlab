function xx = inv_norm(pp,mu,sig)
% INV_NORM - Inverse cdf for the normal distribution
%   xx = INV_NORM(pp,mu,sig) returns the inverse cdf for the normal
%   distribution with mean MU and standard deviation SIG at the 
%   (cumulative) probabilities pp.

if nargin<2
  mu=0;
end
if nargin<3
  sig=1;
end

xx = erfinv(2*pp-1)*sqrt(2)*sig + mu;