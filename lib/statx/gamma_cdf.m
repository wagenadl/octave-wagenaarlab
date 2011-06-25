function y = gamma_cdf(x,gam,mu,beta)
% y = GAMMA_CDF(x,gamma,mu,beta) returns the cdf of the 
% Gamma pdf at X. 
% Default parameter values: GAMMA=1, MU=0, BETA=1

if nargin<2
  gam=1;
end
if nargin<3
  mu=0;
end
if nargin<4
  beta=1;
end

z = (x-mu)/beta;
ok=z>0;
y=0*x;
y(ok) = gammainc(z(ok),gam);
