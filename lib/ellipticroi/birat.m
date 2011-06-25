function [rat, srat, trat] = birat(cc,scc,tcc, ox,sox,tox)
% [rat, srat, trat] = BIRAT(cc,scc,tcc, ox,sox,tox) computes ratios between
% Coumarin and Oxonal images.
% CC, OX must means of individual cells (TxN).
% SCC, SOX must be their errors.
% TCC, TOX must be timestamps. It is assumed that for all n, TCC(n)<TOX(n)<TCC(n+1).
% Note: RAT(1:2:end,:) are the "conventional" ratios, while
% RAT(2:2:end-1,:) are the intermediate, but equally valid ones.
% CAUTION: These intermediates are not statistically independent
% from the conventional points. (But they are stat. indep. from each other.)
% Output is (2*T-1)xN.

[T,N] = size(cc);

tcc=tcc(:); tox=tox(:);

rat = zeros(T*2-1,N);
srat = zeros(T*2-1,N);
trat = zeros(T*2-1,1);

rat(1:2:end,:) = cc./ox;
rat(2:2:end,:) = cc(2:end,:)./ox(1:end-1,:);

trat(1:2:end) = (tcc+tox)/2;
trat(2:2:end) = (tcc(2:end)+tox(1:end-1))/2;

srat(1:2:end,:) = rat(1:2:end,:).*sqrt((scc./cc).^2+(sox./ox).^2);
srat(2:2:end,:) = rat(2:2:end,:).*sqrt((scc(2:end,:)./cc(2:end,:)).^2+(sox(1:end-1,:)./ox(1:end-1,:)).^2);
