function p = cdft(t,df)
% CDFT - Cumulative distribution function for the T distribution
%    p = CDFT(t,df) returns the cdf of the T distribution with DF
%    degrees of freedom, at the value in T.
%
%    This version uses a table, and can only return a limited set
%    of probabilities. Call without arguments to retrieve the set.
%    For df>100, an infinity approximation is used.

load ttable.mat;

if nargin==0
  p=[fliplr(pp) 0.5 1-pp];
  return
end

S=size(t);
t=t(:);
df=df(:);
p=zeros(prod(S),1);
for s=1:prod(S)
  if df(s)<=0
    p(s)=.5;
  else
    if df>100
      tc=tinf;
    else
      tc=tt(df,:);
    end
    t_=abs(t(s));
    ok = t_>tc;
    n=sum(ok);
    if n>0
      p(s)=pp(n);
    else
      p(s)=.5;
    end
  end
end
p(sign(t)>0) = 1 - p(sign(t)>0);

p=reshape(p,S);
