function [p,t,df] = anova1_compare(a,k1,k2)
% ANOVA1_COMPARE - Simple comparison between two treatments following ANOVA
%    p = ANOVA1_COMPARE(a,k1,k2) returns the result of a t-test between
%    the data in treatment K1 and treatment K2. A must be the result of
%    a call to ANOVA1.
%    [p,t,df] = ANOVA1_COMPARE(a,k1,k2) returns t-value and degrees of freedom
%    of the test as well.
%    NB: p>.99 means that the mean of K1 is likely larger than the mean of K2,
%        p<.01 means that the mean of K2 is likely larger than the mean of K1.

dmu = a.data.avg(k1) - a.data.avg(k2);
t = dmu/sqrt(a.MSE*(1/a.data.nnn(k1)+1/a.data.nnn(k2)));
df = a.DFE;

p=tcdf(t,df);

if nargout<3
  clear df;
end
if nargout<2
  clear t;
end
