function [Tplus,Tmin,nsr] = wilcoxon_signed_ranks(a,b)
% [Tplus,Tmin,nsr] = WILCOXON_SIGNED_RANKS(a,b) calculates the Wilcoxon signed rank
% test.
% To test for significance, use WILCOXON_SIGNED_RANKS_TEST.
dif = a-b;
idx=find(dif~=0);
dif=dif(idx);
[r,ties] = drank(abs(dif));
r(dif<0)=-r(dif<0);

Tplus=sum(r(r>0));
Tmin=-sum(r(r<0));
nsr = length(idx);

