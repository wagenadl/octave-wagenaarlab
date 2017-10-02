function [R,mu,logl]=mo1g_em_mv(X,K,mu,dlogl)
% [R,mu,logl]=MO1G_EM_MV(X,K,mu0,dlogl) fits a mixture of N(mu,1)
% Gaussians to the data X. If mu0 is specified and non-empty, it
% sets initial values for the centroids.
% This function is tolerant of missing values (NaNs in X).
% X must be NxD.
% If spec'd, mu0 must be KxD.
% If spec'd, dlogl specifies the terminal log likelihood step, 
% default is .0001 N
% Output: R is NxK, mu is KxD, logl is 1x1 log likelihood

if nargin<3
  mu=[];
end
if nargin<4
  dlogl=[];
end

[N D]=size(X);
if isempty(mu)
  mu=zeros(K,D);
  for k=1:K
    while 1
      mu(k,:)=X(ceil(rand(1,1)*N),:);
      if (sum(isnan(mu(k,:)))==0)
	break;
      end
    end
  end
elseif size(mu,1)~=K | size(mu,2)~=D
  error('mu0 must be KxD if specified');
end

if isempty(dlogl)
  dlogl=.0001*N;
end

missing = isnan(X);
pi_=ones(K,1)/K;

lastlogl=-inf;

R=zeros(N,K); partprob=zeros(N,K); totprob=zeros(N,1);

while 1
  % E step: compute responsibilities R(n,k)
  for k=1:K
    bigmu=repmat(mu(k,:),[N 1]);
    X(missing)=bigmu(missing);
    % Note that the above way of dealing with missing values falls flat if
    % we were to add covariance to this function.
    % Calc on 10/23/01p1 shows that this *is* actually the right
    % way to do it in the case cov=eye.
    partprob(:,k) = pi_(k)/sqrt(2*pi) * exp(-.5*sum((X-bigmu).^2,2));
  end
  fullprob=sum(partprob,2)+1e-20;
  logl = sum(log(fullprob));
  for k=1:K
    R(:,k) = partprob(:,k)./fullprob;
  end

%  plot(X(:,2),X(:,1),'b.', mu(:,2),mu(:,1),'r*');
%  logl
%  pause
  
  if logl-lastlogl < dlogl
    return;
  end
  
  % M step: compute new mu
  for k=1:K
    bigmu=repmat(mu(k,:),[N 1]);
    sumR=sum(R(:,k));
    X(missing)=bigmu(missing);
    mu(k,:)=R(:,k)'*X ./ sumR;
    % pi_(k) = sum(R,1) / N;
  end
  
  lastlogl=logl;
end
