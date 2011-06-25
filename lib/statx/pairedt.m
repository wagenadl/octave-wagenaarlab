function [t,nu] = pairedt(x1,x2)
% [t,nu] = PAIREDT(values1,values2)
% This is a paired t-test. See STUDENTT for an unpaired test.

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
