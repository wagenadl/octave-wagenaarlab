function bid = bdtc_id(spks,tt,dd)
% bid = BDTC_ID(spks,tt,dd) assigns burst numbers to spikes in SPKS,
% given TT and DD as returned from BURSTDET_TIMECLUST.

N=length(tt);
bid=zeros(size(spks.time));
for n=1:N
  idx = find(spks.time>=tt(n) & spks.time<tt(n)+dd(n));
  bid(idx)=n;
end
