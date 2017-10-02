function y = mog_init(X,K)
% MOG_INIT provides initialization for mixture of Gaussians EM.
% Input: X: DxN data
%        K: number of clusters
% Output: Structure that can be passed to mog_fullem
% Coding: Daniel Wagenaar, April-May 2000


% initialize parameters
N=size(X,2);
D=size(X,1);
p = (1/K) * ones(1,K);
idx = floor(rand(1,K)*N+1);
mu = X(:,idx);
datvar = diag(var(X')); % a DxD diagonal matrix containing the data variance
for k=1:K
  sig{k} = datvar / 40; % This is arbitrary, and not very clever
end

% return parameters
y.p = p;
y.mu = mu;
y.sig = sig;
return;
