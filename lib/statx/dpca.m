function [pc,w,sig] = dpca(xx,K)
% DPCA - Principal component analysis
%   [pc, w] = DPCA(xx, K) performs a pca on the data in XX.
%   XX must be NxD (each row being an observation).
%   PC will be KxD, containing the first K eigenvectors, and
%   W will be Kx1, containing their weights.
%   If K is not given, all D pcs will be returned.
%   [pc, w, sig] = DPCA(xx, K) also returns the signals associated with
%   the PCs. (These are straightforwardly computed as
%      sig = xx * pc'.)
%   Conversely, the original signals can be approximately reconstructed by
%      xx ~ sig * pc.

[N,D]=size(xx);
if nargin<2
  K=D;
end

PRINCOMP = 1;

if PRINCOMP
  [pc,sig,w] = princomp(xx, 'econ');
  w = w';
  pc = pc';
  DK = K - length(w);
  if DK>0
    w = [w, zeros(1,DK)];
    pc = [pc; zeros(DK,D)];
    sig = [sig, zeros(N, DK)];
  elseif DK<0
    w = w(1:K);
    pc = pc(1:K,:);
    sig = sig(:,1:K);
  end    
else
  cv = cov(xx);
  %[u,d,v]=svds(cv,K);
  %[u,d,v]=svd(cv, K);
  %pc = v(:,1:K)';
  [pc, d] = eigs(cv, K, 'lm');
  pc = pc';
  w = diag(d); w=w(1:K)';
end

if nargout>=3
  sig = xx * pc';
end
