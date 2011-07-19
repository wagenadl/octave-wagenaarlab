function y = modg_partialem(X,par,epsi,lambda,idx)
% MODG_PARTIAL implements the partial update alg for Modg from Ueda et al
% Input: X: DxN data 
%        par: structure with members:
%      	   p:   1xK vector of mixing coefficients
%      	   mu:  DxK matrix of means
%      	   sig: K cell vector of Dx1 matrices of variances
%        epsi: relative change of log likelihood used for termination
%        lambda: fudge parameter to prevent zero-variance attractor
%        idx: index vector specifying which clusters should be updated
% Output: structure with members as par
% Algorithm: Max Welling, in class notes for CS156b and Ueda et al
% Coding:    Daniel Wagenaar, April-May 2000

% some constants
max_iter = 100;
fudge = 1e-6;

% initialize parameters
mu = par.mu;
p = par.p;
sig = par.sig;

N=size(X,2);
D=size(X,1);
K=size(p,2);

% Compute initial responsibilities
R = modg_responsibility(X,par);
primalR = sum(R(:,idx),2); % Nx1 vector of primary total responsibilities

old_likely = -1e9;

nG= (2*pi)^(-D/2);

for iter = 1:max_iter

  lastiter = iter;

  % E step: compute responsibilities
  norma = zeros(1,N);
  R = zeros(N,K); % R(n,k) will be the responsibility of cluster k for point n
  px = zeros(1,N);
  for k = idx
  % This section is copied verbatim from modg_responsibility.m
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
  % End of copied section
  end
  likely = sum(log(px+1e-300)); % This is only the 'local' likelihood
                         % within the idx group

  if (abs((likely - old_likely)/likely) < epsi)
    break;
  end
  old_likely = likely;
  
  norma = primalR ./ (norma+1e-300)';
  for k = idx
    R(:,k) = R(:,k) .* norma;
  end

  % M step: recompute mu, sig, p
  for k = idx
    sumR = sum(R(:,k));
    mu(:,k) = (X*R(:,k)) ./ (sumR+fudge); % DxN * Nx1 = Dx1
    dx = X - repmat(mu(:,k),[1 N]);
    dxdx = dx.*dx; % DxN 
    Rdxdx = dxdx*R(:,k); % Dx1
    sig{k} = (Rdxdx + lambda*ones(D,1))/(sumR+lambda); 
    p(k) = mean(R(:,k));
  end
  
end

% return parameters
y.p = p;
y.mu = mu;
y.sig = sig;
y.iters = lastiter;
y.R = R;
return;
