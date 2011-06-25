function yy = spikehist(tms,chs,tt)
% yy = SPIKEHIST(tms,chs,tt) returns a 60xT histogram of spikes.

yy = zeros(60,length(tt));
for hw=0:59
  idx = find(chs==hw & tms>=tt(1) & tms<=tt(end));
  yy(hw+1,:) = hist(tms(idx),tt);
end

