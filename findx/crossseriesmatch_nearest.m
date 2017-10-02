function idx = crossseriesmatch_nearest(tt1,tt2,strict)
% idx = CROSSSERIESMATCH_NEAREST(tt1,tt2) finds, for each time t in series TT1,
% the corresponding entry t' in TT2 such that t' is closest to t of all
% the values in TT2.
% As a result, some entries in TT2 may be matched to multiple entries
% in TT1. If this is not desirable, use
% idx = CROSSSERIESMATCH_NEAREST(tt1,tt2,1).
% Entries in TT1 for which there is no match in tt2 will return 0 in idx.
%
% Caution: this assumes that both TT1 and TT2 are pre-sorted.
% NB: With STRICT, this function needs to sort distances, so is
% O(N*log(N)) rather than O(N).

if nargin<3
  strict=0;
end

idx_fwd = crossseriesmatch(tt1,tt2,strict);
idx_bwd = crossseriesmatch_reverse(tt1,tt2,strict);

dt_fwd = inf+zeros(size(tt1));
dt_bwd = inf+zeros(size(tt1));
dt_fwd(idx_fwd>0) = tt2(idx_fwd(idx_fwd>0)) - tt1(idx_fwd>0);
dt_bwd(idx_bwd>0) = tt1(idx_bwd>0) - tt2(idx_bwd(idx_bwd>0));

if strict
  idx = zeros(size(tt1));
  revidx = zeros(size(tt2));
  potpair1 = [ [1:length(tt1)] [1:length(tt1)]];
  potpair2 = [idx_fwd(:) idx_bwd(:)];
  potdist = [dt_fwd(:) dt_bwd(:)];
  use = potdist<inf;
  potpair1=potpair1(use);
  potpair2=potpair2(use);
  potdist=potdist(use);
  [dist,ord] = sort(potdist);
  N=length(potdist);
  for n=1:N
    i1=potpair1(ord(n));
    i2=potpair2(ord(n));
    if idx(i1)==0 & revidx(i2)==0
      idx(i1)=i2;
      revidx(i2)=i1;
    end
  end
else
  idx = idx_fwd;
  idx(dt_bwd<dt_fwd) = idx_bwd(dt_bwd<dt_fwd);
end
