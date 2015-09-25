function [t,nu] = pairedt(x1,x2)
% PAIREDT - Student T test statistic for paired samples
%    [t, nu] = PAIREDT(values1, values2)
%    The number of samples must be equal!
%    Use p =  1 - TCDF(t, nu) to get confidence level.

mu1 = mean(x1);
mu2 = mean(x2);
dx1 = x1-mu1;
dx2 = x2-mu2;
n = length(x1);
if n~=length(x2)
  error('pairedt must have matching inputs');
end
t = (mu1-mu2)*sqrt(n*(n-1) / sum((dx1-dx2).^2));
nu = n-1;
