function avgs = extractshiftedavgs(imgs,xyrras,R,idx,ref,tst)
% EXTRACTSHIFTEDAVGS - Many cell version of EXTRACTSHIFTED
%    avgs = EXTRACTSHIFTEDAVGS(imgs,xyrras,R) where IMGS is YxXxTxQ and
%    XYRRAS is a Qx1 cell array of Nx5 matrices returns average brightness
%    of N cells in Q channels using EXTRACTSHIFTED to correct for motion
%    artifacts. Output is NxQ.
%    As for EXTRACTSHIFTED, output is not normalized or debleached.
%    Note that XYRRAS must be Nx5, unlike the older 5xN format used in
%    EXTRACTELLIPTICROIS.

[Y X T Q]=size(imgs);
if ~iscell(xyrras)
  xyrras={xyrras};
end
if nargin<5 | isempty(ref)
  ref=1;
end
if nargin<4 | isempty(idx)
  idx=[1:T];
end
if nargin<6
  tst=0;
end
[N five]=size(xyrras{1});

avgs=zeros(T,N,Q);

for n=1:N
  for q=1:Q
    xyr{q} = xyrras{q}(n,:);
  end
  pxs = extractshifted(imgs,xyr,R,idx,ref,tst);
  for q=1:Q
    avgs(:,n,q) = mean(pxs{q},1)';
  end
end
