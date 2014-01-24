function [pc,w] = dpca(xx,K)
% DPCA - Principal component analysis
% [pc,w] = DPCA(xx,K) performs a pca on the data in XX.
% XX must be NxD.
% PC will be KxD, containing the first K eigenvectors, and
% W will be Kx1, containing their weights.
% If K is not given, all D pcs will be returned.

[N,D]=size(xx);
if nargin<2
  K=D;
end

cv = cov(xx);
%[u,d,v]=svds(cv,K);
[u,d,v]=svd(cv);
pc = v(:,1:K)';
w = diag(d); w=w(1:K)';
