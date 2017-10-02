function R = modg_responsibility(X,par)
% MODG_RESPONSIBILITY performs the e step of modg. Using this
% function within a loop will be slow. However, it is nice and easy 
% to use for non-looping calcs e.g. at the start of partialem and
% when calculating split/merge merits.
% Input: X, par as for modg_fullem
% Output: R: NxK responsibility matrix
% Algorithm: Max Welling/DW
% Coding: DW, 10/00

mu = par.mu;
p = par.p;
sig = par.sig;

N=size(X,2);
D=size(X,1);
K=size(p,2);

norma = zeros(1,N);
R = zeros(N,K); % R(n,k) will be the responsibility of cluster k for point n
px = zeros(1,N);
nG = (2*pi)^(-D/2);
for k=1:K
  s = sig{k};
  siginv = 1./s;
  detsig = prod(s);
  dx = X - repmat(mu(:,k),[1 N]);
    dxdx = dx.*dx; % DxN
    sdxdx = siginv' * dxdx; % 1xN
    G = nG/sqrt(detsig) * exp(-.5*sdxdx); % a 1xN vector of p(x|k)
  pG = p(k)*G;
  px = px + pG;
  norma = norma + pG;
  R(:,k) = pG';
end

for k=1:K
  R(:,k) = R(:,k) ./ (norma+1e-300)';
end
