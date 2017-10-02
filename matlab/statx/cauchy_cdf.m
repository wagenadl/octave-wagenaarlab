function y = cauchy_cdf(x,t,s)
% y = CAUCHY_CDF(x,t,s) returns the cdf of the Cauchy pdf at X. 
% Default parameter values: T=0, S=1.

if nargin<2
  t=0;
end
if nargin<3
  s=1;
end

z=(x-t)/s;
y = .5+atan(z)/pi;
