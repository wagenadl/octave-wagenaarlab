function bb=burstextent(bb,times,channels,overallrate)
% bb=BURSTEXTENT(bb,times,channels) compute duratinon and channel-map 
% for bursts found by BURSTDET or BURSTDET2.
% Optional 4th argument OVERALLRATE specifies the baseline firing rate
% for each channel.

B=length(bb.onset);
bb.onoff = bb.offset-bb.onset;
bb.chanmap=logical(zeros(B,60));
bb.nchans=zeros(B,1);
bb.nspikes=zeros(B,1);
if nargin<4 | isempty(overallrate)
  overallrate = hist(times,[0:60]) / (max(times)-min(times));
end
overallrate=overallrate(1:60);
overallrate=overallrate(:)';
for b=1:B
  idx=find(times>=bb.onset(b) & times<=bb.offset(b));
  bb.nspikes(b)=length(idx);
  if ~isempty(idx)
    chmap=zeros(1,64);
    nowrate = hist(channels(idx),[0:60]) / bb.onoff(b);
    bb.chmap(b,:)=logical(nowrate(1:60) > 2*overallrate);
    bb.nchans(b)=sum(bb.chmap(b,:));
  end
end
bb.overallrate = overallrate;

  