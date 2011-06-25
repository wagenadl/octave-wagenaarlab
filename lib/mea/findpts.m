function [ispts,starts,ends] = findpts(lat,minn,dt,sprd)
% ispts = FINDPTS(lat,minn,dt) decides which spikes are pts.
% Decision is purely based on latencies LAT.
% A histogram is created, blurred by DT us. (Default: DT=160.)
% Then, any bin that has at least MINN spikes in it, is considered a pts.
% Any spikes in that bin, or within DT us of that bin are marked pts.
% FINDPTS(...,sprd) specifies an alternative width for marking (SPRD in us).
% [ispts,starts,ends] = FINDPTS(...) also returns start and end times
% of putative pts peaks.

if nargin<3
  dt = [];
end
if nargin<4
  sprd = [];
end
if isempty(dt)
  dt = 160;
end
if isempty(sprd)
  sprd = dt;
end

ispts = logical(zeros(size(lat)));

xx = [0:.040:50]; 
yy = hist(lat,xx);
yy(end) = 0;
yy = gaussianblur1d(yy,dt/40);
pks = find(yy>=minn); P=length(pks);
if P>0
  starts = xx(pks)-sprd/1000;
  ends = xx(pks)+sprd/1000;
  for p=1:P
    ispts(lat>=starts(p) & lat<=ends(p)) = logical(1);
  end
else
  starts = [];
  ends = [];
end
