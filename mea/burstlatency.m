function bb=burstlatency(bb,stimtimes)
B=length(bb.onset);
bb.latency=zeros(B,1);
for b=1:B
  dt = bb.onset(b) - stimtimes;
  [m,id] = min(dt.^2);
  bb.latency(b) = bb.onset(b) - stimtimes(id);
end
