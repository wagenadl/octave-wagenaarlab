function ss_spikeinspect(spikes)
% SS_SPIKEINSPECT - Crude inspection of detected spikes

if isfield(spikes, 'hierarchy')
  asg = spikes.hierarchy.assigns;
elseif isfield(spikes, 'overcluster')
  asg = spikes.overcluster.assigns;
elseif any(isinf(spikes.threshV))
  asg = ceil(spikes.spiketimes*10/max(spikes.spiketimes));
else
  asg = 1 + (spikes.amplitude<0);
end

N = max(asg);
cc = jet((N-1)*10+1);
cc = [[.5 .5 .5]; cc(1:10:end,:)];

tt = ([1:size(spikes.waveforms,2)]-spikes.threshT)*1000/spikes.Fs;
cla
for n=0:N
  idx = find(asg==n);
  if ~isempty(idx)
    plot(tt,spikes.waveforms(idx,:)', 'color', cc(n+1,:));
    hold on
  end
end
