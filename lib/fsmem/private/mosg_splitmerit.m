function J = mosg_splitmerit(X,par,R)
% MOSG_SPLITMERIT computes the split merit matrix for Mosg SMEM
% Input: X, par: as for mosg_fullem
%        R: NxK responsibility matrix as from mosg_responsibility
% Output: Kx1 split merit vector
% Algorithm: Ueda et al
% Coding: DW

% Jsplit_k := int dx f_k(x) log (f_k(x) / p(x|theta_k)),
% where f_k(x) := (sum_n delta(x-x_n) R_kn) / (sum_n R_kn)
% This can be re-expressed as
% Jsplit_k := sum_n f_kn log (f_kn / p_nk), [1]
% where f_kn := R_kn / sum_m R_km and p_nk = p(x|theta_k).
% This is not quite true: int dx delta(x-y) log delta(x-y)*f(x) [2]
% isn't quite equal to log f(y), but I suspect Ueda et al haven't
% been careful about this either. Strictly, of course, the integral 
% [2] diverges. I suspect that the divergent term originates from
% the fact that the KL distance between a continuous and a discreet 
% pdf is necessarily divergent. I hope the above prescription [1] is
% the sensible one.

fudge = 1e-6;

mu = par.mu;
p = par.p;
sig = par.sig;

N=size(X,2);
D=size(X,1);
K=size(p,2);

J=zeros(K,1);

nG = (2*pi)^(-D/2);

for k=1:K
  % This section is copied verbatim from mosg_responsibility.m
  s = sig{k};
  siginv = 1/s;
  detsig = s^D;
  dx = X - repmat(mu(:,k),[1 N]);
  sdx = siginv * dx;
  expo = -.5 * sum(dx .* sdx,1);
  G = nG/sqrt(detsig) * exp(expo); % a 1xN vector of p(x|k)
  % End of copied section
  
  f = R(:,k) ./ (sum(R(:,k))+fudge);
  G = G + .00001;
  idx = find(f>.00001);
  J(k) = sum(f(idx).*log(f(idx)./G(idx)'));
end
