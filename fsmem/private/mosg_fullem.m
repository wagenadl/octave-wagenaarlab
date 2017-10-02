function y = mosg_fullem(X,par,epsi,lambda)
% MOSG_FULLEM implements the EM algorithm for mixture of Gaussians.
% Input: X: DxN data 
%        par: structure with members:
%      	   p:   1xK vector of mixing coefficients
%      	   mu:  DxK matrix of means
%      	   sig: K cell vector of 1x1 variances
%        epsi: relative change of log likelihood used for termination
%        lambda: fudge parameter to prevent zero-variance attractor
% Output: structure with members as par, plus
%   likely: log likelihood at end of run
% Algorithm: Max Welling, in class notes for CS156b
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

old_likely = -1e9;

nG = (2*pi)^(-D/2);

for iter = 1:max_iter

  iter
  
  lastiter = iter;
  
  % E step: compute responsibilities
  norma = zeros(1,N);
  R = zeros(N,K); % R(n,k) will be the responsibility of cluster k for point n
  px = zeros(1,N);
  for k=1:K
  % This section is copied verbatim from mosg_responsibility.m
    s = sig{k};
    siginv = 1/s;
    detsig = s^D;
    dx = X - repmat(mu(:,k),[1 N]);
    sdx = siginv * dx;
    expo = -.5 * sum(dx .* sdx,1);
    G = nG / sqrt(detsig) * exp(expo); % a 1xN vector of p(x|k)
    pG = p(k)*G;
    px = px + pG;
    norma = norma + pG;
    R(:,k) = pG';
  % End of copied section
  end
  
  for k=1:K
    R(:,k) = R(:,k) ./ (norma+1e-300)';
  end
  
%  figure(1); plot(px); figure(2); plot(p); sum(p)
%  figure(3); hist(log(px));
%  pause
  likely = sum(log(px+1e-300));

  likely
  
  if (abs((likely - old_likely)/likely) < epsi)
    break;
  end
  old_likely = likely;

  % M step: recompute mu, sig, p
  for k=1:K
    sumR = sum(R(:,k));
    mu(:,k) = (X*R(:,k))./(sumR+fudge); % DxN * Nx1 = Dx1
    dx = X - repmat(mu(:,k),[1 N]); % DxN
    dxdx = dx.*dx;
    sdxdx = sum(dxdx,1); % 1xN
    Rsdxdx = sum(sdxdx*R(:,k)); % 1x1
    sig{k} = (Rsdxdx + D*lambda)/((sumR+lambda)*D);
    % sig{k} = (Rdx * dx')/sumR; % DxN * NxD = DxD
  end
  p = mean(R,1);
   
  p
  mu
  showsig = zeros(1,K);
  for k=1:K
    showsig(k) = sig{k};
  end
  showsig

end

% return parameters
y.p = p;
y.mu = mu;
y.sig = sig;
y.likely = likely - .5*log(N)*K*(1+D+1); % Subtract MDL term
y.iters = lastiter;
y.R = R;
return;
