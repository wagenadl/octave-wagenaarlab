function y = modg_mergeinit(par, k, l, epsi)
% MODG_MERGEINIT(par,k,l,epsi) initializes the parameters for clusters k
% and l as the merges of cluster k and l into one. The result is
% stored in cluster k, and p(l) is set to zero.
% Input: par: parameters as for all modg fns
%        k: source cluster 1, also dest. cluster
%        l: source cluster 2
% Output: structure of updated parameters
% Alg: Ueda
% Coding: DW

y=par;

y.p(k) = par.p(k)+par.p(l);
y.mu(:,k) = (par.mu(:,k) + par.mu(:,l)) ./ 2;
y.sig{k} = (par.sig{k} + par.sig{l}) ./ 2;
y.p(l) = 0;
