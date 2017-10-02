function proj=whitepc(ctxt, noise, n)
% proj=WHITEPC(ctxt, noise, n) returns a projection matrix for
% pre-whitened principal components.
% That is, it finds the first N principal components of the
% covariance matrix of CTXT. Then, it reshapes the NOISE to WxL,
% projects it to pc space, and computes the covariance matrix in that
% space. It then finds a projection to make that matrix into the
% identity matrix, and multiplies it into the PC projector. The result
% is a projection from context space to (rotated and scaled) PC space
% that whitens the background noise.
% Input: 
%   ctxt: WxM result from ctxtupsample, W=width of context, M=# of spikes
%   noise: long vector of background signal
%   n: (scalar) number of pcs to use.
% Output: NxW projection matrix

[W M]=size(ctxt);
L=length(noise);

cova=cov(ctxt');
[U S V] = svd(cova);
projpc=V'; projpc=projpc(1:n,:);

NN=floor(L/W); % Number of usable noise windows
L=NN*W;
noiseparts=reshape(noise(1:L),W,NN);
noiseparts=projpc*noiseparts;
% So now noiseparts is NxNN noise in PC space
[U S V] = svd(cov(noiseparts'));
projnoise=eye(n)/sqrt(S) * V';
plot(projpc');
proj = projnoise * projpc;
