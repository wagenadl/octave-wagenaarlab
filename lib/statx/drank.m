function [r,ties] = drank(xx)
% r = DRANK(xx) returns the ranks of the data points XX.
% For splits, the rank is the mean of all repeated values.
% [r,ties] = DRANK(xx) returns a vector of ties. Each value in TIES 
% is the number of repeats for a given value.

[val,ord] = sort(xx);
dif=[inf diff(val(:)') inf];
istie = dif==0;
tiestart = find(diff(istie)>0);
tieend = find(diff(istie)<0);
T=length(tiestart);
ties = tieend-tiestart + 1;
rr=[1:length(xx)];
for t=1:T
  rr(tiestart(t):tieend(t)) = mean(rr(tiestart(t):tieend(t)));
end
r=rr; r(ord)=rr;
if nargout<2
  clear ties
end
