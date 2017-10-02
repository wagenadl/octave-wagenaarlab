function p = fisherexact(aa,bb,zok)
% FISHEREXACT - Fisher Exact Probability Test
%   p = FISHEREXACT(aa,bb) returns the probability quantile of the
%   binary variables AA and BB coming from the same Bernoulli distribution.
%   That is, if they do, P will be close to 0.5; if there are relatively 
%   fewer "ones" in AA than in BB, P will be closer to 0.
%   p = FISHEREXACT(aa,bb,1) is the same, but will allow approximation
%   by the normal distribution if the number of points is large.
%   Note that the fisher exact test is not symmetric: for small samples,
%   the test that mean(AA) < mean(BB) is the one to use: i.e., reported
%   p-values close to zero are conservative, p-values close to one should
%   be treated with skepticism. Reverse the test when in doubt!

if nargin<3
  zok=0;
end

N0 = 50; % Minimum number for which we approximate.
N1 = 85; % Maximum number beyond which we must approximate

aa=aa>.5; % Make sure we're binary!
bb=bb>.5;

na = length(aa);
pa = mean(aa);
nb = length(bb);
pb = mean(bb);

if zok & (na>=N1 | nb>=N1 | (na>=N0 & nb>=N0))
  % Approximate
  p0 = (na*pa+nb*pb) / (na+nb);
  z = (pa - pb) / sqrt(p0*(1-p0)*(1/na + 1/nb));
  p = normcdf(z);
else
  if na>=N1 | nb>=N1
    error 'fisherexact: N too large; approximation is required'
  end
  A1 = sum(aa)
  B1 = sum(bb)
  nn = na+nb
  pp=[];
  for dd=0:nn
    a1=A1-dd;
    b1=B1+dd;
    if a1>=0 & b1<=nb
      a0 = na - a1;
      b0 = nb - b1;
      fa1 = factorial(a1+a0)/factorial(a1);
      fa2 = factorial(b1+b0)/factorial(b0);
      fa3 = factorial(a0+b0)/factorial(a0);
      fa4 = factorial(a1+b1)/factorial(b1);
      pp(end+1) = fa1*fa2*fa3*fa4 / factorial(nn);
    end
  end
  pp(1)
  p = sum(pp);
end
