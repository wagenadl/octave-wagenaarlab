function idx = crossseriesmatch(tt1,tt2,strict)
% idx = CROSSSERIESMATCH(tt1,tt2) finds, for each time t in series TT1,
% the corresponding entry t' in TT2 such that t' is the smallest time in
% TT2 for which t<=t'.
% As a result, some entries in TT2 may be matched to multiple entries
% in TT1. If this is not desirable, use
% idx = CROSSSERIESMATCH(tt1,tt2,1).
% Entries in TT1 for which there is no match in tt2 will return 0 in idx.
%
% Caution: this assumes that both TT1 and TT2 are pre-sorted.

if length(find(size(tt1)>1))>1 | length(find(size(tt2)>1))>1
  error('crossseriesmatch only works on vectors');
end
if isempty(tt1) | isempty(tt2)
  idx=zeros(size(tt1));
  return
end

if nargin<3
  strict=0;
end

t1 = real(double(tt1(:)));
t2 = real(double(tt2(:)));
idx = crossseriesmatch_core(t1,t2);
idx = double(idx);

if strict
  dd = find(diff(idx)==0);
  idx(dd)=0;
end

idx = reshape(idx,size(tt1));