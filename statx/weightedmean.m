function [mu,sem,b] = weightedmean(xx,ww)
% WEIGHTEDMEAN - Calculate weighted mean and SEM from data
%    mu = WEIGHTEDMEAN(xx,ww) calculates the weighted mean of the
%    data XX using weights WW.
%    [mu,sem,b] = WEIGHTEDMEAN(xx,ww) also returns an unbiased estimate of
%    the standard error on that mean as well as the "effective base" for that
%    estimate.
%    Any point with either XX or WW NaN is given zero weight.

%    We calculate the effective base as:
%
%                    2
%            (sum WW)
%       B = -----------
%                   2
%            sum [WW ]
%
%    and the SEM as:
%                                         2     1/2
%              /  1    B    sum [WW (XX-MU) ]  \
%       SEM = |  --- ----- -------------------  |
%              \  B   B-1        sum WW        /
%
%                xxx  +++  *******************
%
%    (Here, **** is the calculation of population variance,
%            +++ is the correction factor needed because MU is estimated
%                rather than given
%            xxx converts from std.dev. to SEM.)
 
bd=isnan(xx) | isnan(ww);
xx(bd)=0; ww(bd)=0;

mu = sum(xx.*ww) ./ sum(ww);
if nargout>=2
  b = sum(ww).^2 / sum(ww.^2);
  s2_unc = sum(ww.*(xx-mu).^2) / sum(ww);
  % s2_unc is the population variance, not the sample variance
  s2_cor = s2_unc * b/(b-1);
  sem = sqrt(s2_cor/b);
end
if nargout<3
  clear b
end

function tester
for k=1:1000
  yy=randn(10,100);
  uu=rand(10,100)>.5;
  nn=sum(uu);
  xx=sum(uu.*yy)./nn;
  ww=nn;
  [mu(k),sig(k),b]=weightedmean(xx,ww);
end
