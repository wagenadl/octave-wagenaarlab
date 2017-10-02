function [ispts,starts,ends] = findpts_sr(lat,stm,rec,minn,dt,sprd)
% ispts = FINDPTS_SR(lat,stm,rec,minn,dt,sprd) uses FINDPTS to locate pts
% in a multi-site stim/rec experiment.
% STM, REC are stimulation and recording electrodes, numbered 0..59.
% [ispts,starts,ends] = FINDPTS_SR(...) also returns SxR cell arrays
% of putative start and end times of pts

if nargin<5
  dt = [];
end
if nargin<6
  sprd = [];
end

ispts = logical(zeros(size(lat)));
starts=cell(60,60);
ends=cell(60,60);

for s=0:59
  idxs = find(stm==s);
  if ~isempty(idxs)
    for r=0:59
      idxr = idxs(find(rec(idxs)==r));
      if ~isempty(idxr)
	[ispts(idxr),starts{s+1,r+1},ends{s+1,r+1}] = findpts(lat(idxr),minn,dt,sprd);
      end
    end
  end
end
