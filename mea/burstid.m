function bid=burstid(bb,times)
% bid = BURSTID(bb,times) assigns burst numbers from bursts in BB to spikes
% in TIMES. BB must be the result of BURSTDET or BURSTDET2; TIMES must be
% the spike times originally fed to BURSTDET.
B=length(bb.onset);
bid=0*times;
for b=1:B
  idx=find(times>=bb.onset(b) & times<=bb.offset(b));
  if ~isempty(idx)
    bid(idx) = b;
  end
end
