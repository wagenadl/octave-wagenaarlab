function [t,df] = tmeans(mu1, mu2, sig1, sig2, n1, n2)
% [t,df] = TMEANS(mu1, mu2, sig1, sig2, n1, n2) returns the t-statistic
% and degrees of freedom for comparing two distributions with means
% MU1 and MU2, sample standard deviations SIG1 and SIG2 and sample
% sizes N1 and N2.

t = (mu1-mu2) / sqrt(sig1.^2/n2 + sig2.^2/n1);
if nargout>=2
  df = n1+n2-2;
end

