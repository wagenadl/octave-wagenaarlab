function y =mog_gendata(D,N,K,sig)
% y=MOG_GENDATA(D,N,K,sig) generates DxN data points from a mixture of
% K gaussians with typical variance set by sig.
% y.X is the DxN data
% y.par contains the parameters:
%   p: 1xK
%   mu: DxK
%   sig: {K} DxD
%   R: NxK responsibilities (one 1 per row, rest 0s)


X=zeros(D,0);
N0=1;
Nr=N;
Kr=K;
R=zeros(N,K); % responsibilities

MEAN=zeros(D,0);
P=zeros(1,0);

for k=1:K
  % Compute variance matrix
  Rot = eye(D);
  for d=1:D
    for e=(d+1):D
      theta = rand(1) * 2*pi;
      rot = eye(D);
      rot(d,d) = cos(theta);
      rot(e,e) = cos(theta);
      rot(d,e) = sin(theta);
      rot(e,d) = -sin(theta);
      Rot = rot*Rot;
    end
  end
  Rot = sig*Rot*diag(randn(D,1) + 1);
  SIG{k} = Rot*Rot';
  % So now SIG is a randomly rotated covariance matrix
  Mean = randn(D,1);
  MEAN = cat(2,MEAN,Mean);
  Nk = floor((rand(1)+1.5)*(.5*Nr/Kr));
  if ((Nk>Nr) | (Kr==1))
    Nk = Nr;
  end
  P = cat(2,P,Nk/N);
  X = cat(2,X,Rot*randn(D,Nk)+repmat(Mean,1,Nk));
  R(size(X,2),k) = 1;
  Nr = Nr - Nk;
  Kr = Kr - 1;
end

par.mu=MEAN;
par.sig = SIG;
par.p = P;
figure(3);
plot_mog(par,X);
y.X = X
y.par = par;