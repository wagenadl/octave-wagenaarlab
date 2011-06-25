function [t,nu] = studentt(x1,x2)
% [t,nu] = STUDENTT(values1,values2)
% The number of samples doesn't have to be equal!
% Use p = invt(t,nu) to get confidence level.
mu1 = mean(x1);
sig1 = var(x1);
mu2 = mean(x2);
sig2 = var(x2);
n1 = length(x1);
n2 = length(x2);

A=(n1+n2) / (n1*n2);
B=((n1-1)*sig1+(n2-1)*sig2) / (n1+n2-2);

t = (mu1-mu2) / sqrt(A*B);
nu = n1+n2-2;
