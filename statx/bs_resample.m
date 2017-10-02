function y = bs_resample(x)
% BS_RESAMPLE  Random resampling from data for Bootstrap
%    y = BS_RESAMPLE(x) returns a random resampling (with replacement) from
%    the data X.
%    This can be used for bootstrapping. For instance, if you want to know
%    the uncertainty in some statistic f(X), you could do:
%
%      ff=zeros(1,1000); for k=1:1000, ff(k) = f(resample(x)); end
%  
%    Then, std(ff) will be the uncertainty in f, and after ff=sort(ff),
%    ff(25) and ff(975) represent the 95% confidence interval.
%
%    This operates in the first dimension of X, even if X is 1xN.
%    If X is NxD, this resamples the D-dimensional data as expected.
%
%    Note that if ff(975)-ff(25) does not correspond to 4*std(ff), the
%    output of the bootstrap is not normally distributed, which is a
%    sign of potential trouble.
%    It may be better to use "bootstrap bias-corrected accelerated" (BCa) 
%    or "bootstrap tilting" methods to estimate the confidence intervals.

N=size(x,1);
n=ceil(rand(N,1)*N);
y = x(n,:);

