function plot_projs(X,R,N,M)
% PLOT_PROJS(X,R,N,M) plots NxM projections using plot_proj. The
% projection matrices are generated on the spot using rnd_proj, but
% the RNG seed is fixed so the results are reproducible.
% After plotting, the RNG is reset to its prior state. NOT!
% Input: X: DxN data matrix
%        R: NxK responsibilities
%        N,M: integers

D = size(X,1);
P = N*M;
rng = rand('state');
rand('state',4357980279);
k=1; l=2;
mx = D;
if mx>3*sqrt(P)
  mx=floor(3*sqrt(P));
end
for p=1:P
  subplot(N,M,p);
  ax=zeros(D,1); ax(k,1)=1; ax(l,2)=1;
%  plot_proj(X,R,rnd_proj(D,2));
  plot_proj(X,R,ax);
  xlabel(sprintf('%i',k));
  ylabel(sprintf('%i',l));
  l=l+1;
  if l>mx
    k=k+1;
    l=k+1;
    if l>mx
      return;
    end
  end
end
rand('state',rng);