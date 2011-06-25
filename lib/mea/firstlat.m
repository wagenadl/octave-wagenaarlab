function lat=firstlat(spk,minlat)
% lat = FIRSTLAT(spk) returns latencies to first spike on each channel
% for each trial in spk.
% lat = FIRSTLAT(spk,minlat) ignores any spikes before MINLAT.

if nargin<2
  minlat=0;
end

R = max(spk.tri)-1; % Number of trials
lat = zeros(60,R) + nan;
for r=0:59
  fprintf(1,'firstspike %i/60.   \r',r);
  idx = find(spk.chs==r & spk.tri>0 & spk.tri<=R & spk.lat>=minlat);
  if ~isempty(idx)
    lt = spk.lat(idx);
    tr = spk.tri(idx);
    frst = [1; diff(tr)];
    isfrst = find(frst);
    lat(r+1,tr(isfrst)) = lt(isfrst);
  end
end
fprintf(1,'\n');
