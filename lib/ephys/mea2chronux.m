function spikes = mea2chronux(spk)
% MEA2CHRONUX - Convert MEABench spikes to Chronux format
%    spikes = MEA2CHRONUX(spk), where SPK is a structure of spikes as loaded
%    by MEABench's loadspike to a format that Chronux / UltraMegaSort can
%    understand.

for c=1:60
  idx = find(spk.channel==c-1);
  spikes{c} = ss_default_params(25e3);
  %  spikes{c}.Fs = 25000;
  spikes{c}.spiketimes = spk.time(idx);
  spikes{c}.threshT = 20;
  spikes{c}.waveforms = spk.context(6:65,idx);
  spikes{c}.threshV = abs(spk.thresh(idx)).*sign(spikes{c}.waveforms(20,:));
  % I don't think anything else is required
end
