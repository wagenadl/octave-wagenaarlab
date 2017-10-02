function y = mog_splitinit(par, k, l, epsi)
% MOG_SPLITINIT(par,k,l,epsi) initializes the parameters for clusters k
% and l as the split of cluster k into two. The original cluster l
% is destroyed. Normalization is lost unless par.p(l) was zero
% before the call.
% Input: par: parameters as for all mog fns
%        k: source cluster, also dest. cluster 1
%        l: destination cluster 2
%        epsi: scale of noise to be added to mean
% Output: structure of updated parameters
% Alg: Ueda / DW
% Coding: DW

D=size(par.mu,1);

y=par;
y.p(k) = par.p(k)/2;
y.p(l) = y.p(k);

[ U DD V ] = svd(par.sig{k});
stddev = sqrt(diag(DD));

% Move centres away according to principal components:
y.mu(:,k) = par.mu(:,k) + epsi.*U*(stddev.*randn(D,1));
y.mu(:,l) = par.mu(:,k) + epsi.*U*(stddev.*randn(D,1));

% Set sigma to maximal component (really primitive, I admit):
y.sig{k} = DD(1,1) * eye(D);
y.sig{l} = y.sig{k};
