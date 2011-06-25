function y = weibull_cdf(x,gamma,mu,alpha)
% y = WEIBULL_CDF(x,gamma,mu,alpha) returns the cdf of the 
% Weibull pdf at X. 
% Default parameter values: GAMMA=1, MU=0, ALPHA=1

if nargin<2
  gamma=1;
end
if nargin<3
  mu=0;
end
if nargin<4
  alpha=1;
end

z = (x-mu)/alpha;

y = 1 - exp(-z.^gamma);
y(z<0)=0;