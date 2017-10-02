function cutcore(ifn,ofn,t0,t1,retime)
% CUTCORE(ifn,ofn,t0,t1) takes all spikes and trials from IFN with times
% between T0 and T1 and saves them into OFN. Trials are renumbered.
% CUTCORE(...,1) subtracts t0 from all timestamps.

if nargin<5
  retime=0;
end

load(ifn);

tidx = tri.tms>=t0 & tri.tms<t1;
tidx(end)=1;
revmap=cumsum(tidx);
tidx=find(tidx);

for f=fields(tri)'
  tri.(f) = tri.(f)(tidx);
end

idx = find(spk.tms>=t0 & spk.tms<t1);

for f=fields(spk)'
  spk.(f) = spk.(f)(idx);
end

spk.tri = revmap(spk.tri);

if retime
  spk.tms = spk.tms - t0;
  tri.tms = tri.tms - t0;
end

save(ofn,'spk','tri');

