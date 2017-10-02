function spk = detectspike(dat, tms, varargin)
% SS_DETECTSPIKE - Extract spike times from suction electrode traces
%    spk = SS_DETECTSPIKE(dat, tms) detects spikes in a raw electrode trace 
%    and returns spike times and waveforms in a structure with fields:
%
%       waveforms: spike waveforms
%       spiketimes: spike times (in s)
%       Fs: sampling frequency (in Hz)
%       threshT: where in the waveform the threshold crossing happens
%       threshV: threshold values
%       amplitude: spike peak voltage
%
%    This format can be fed directly to the Chronux spike sorting tools.
%    Note that AMPLITUDE is not part of the Chronux format, and will not be
%    updated by, e.g., SS_OUTLIERS.
%
%    spk = DETECTSPIKE(dat, tms, k, v, ...) specifies additional parameters
%    as (key, value) pairs:
%      thrfac: threshold (specified as factor over RMS noise) (4)
%      tbin: bin size for estimating RMS noise (20 ms)
%      tkill: minimum interval between detectable events (10 ms)
%      nsamp: number of samples of context to save before and after 
%             the threshold crossing. ([20 30])
%      polarity: what polarity of spikes to detect. [] means either, >0 means
%             only positive, <0 means only negative, =0 means whichever is
%             the first phase, =nan means whichever is larger on average.
%             Both heuristics can fail, and will give errors if they are
%             unclear.
%      oversamp: oversample the waveforms by given integer factor
%      usepeak: record timestamp of peak rather than threshold crossing

opts = getopt('thrfac=4 tbin=20 tkill=10 nsamp polarity oversamp usepeak=0', ...
    varargin);

if isempty(opts.nsamp)
  opts.nsamp=[20 30];
end
if length(opts.nsamp)==1
  opts.nsamp = [opts.nsamp opts.nsamp];
end

dat=dat(:);

if prod(size(tms))==1
  fs = tms;
  tstart = 1/fs;
else
  tms=tms(:);
  fs = 1/mean(diff(tms)); % Get sampling frequency
  tstart = tms(1);
end

[b1,a1]=butterhigh1(50/fs);
datf = filtfilt(b1,a1,dat);

if fs>4e3
  [b2,a2]=butterlow1(2e3/fs);
  datf = filtfilt(b2,a2,datf);
end

K=ceil(opts.tbin*.001*fs); % Number of samples in 20 ms.
[pki, thri,thro, thrv] = dwgetspike(datf,[opts.thrfac K 40 opts.tkill*fs/1e3]);
amp = datf(pki);

if opts.usepeak
  usei = pki; 
else
  usei = thri; 
end

if isempty(opts.polarity)
  okpol = pki>0; % accept everything
else
  if opts.polarity==0
    % Which is first phase?
    pthr = mean(amp(amp>0));
    nthr = mean(amp(amp<0));
    pidx = find(amp>pthr);
    nidx = find(amp<nthr);
    % Look at -5 to +5 ms
    [xc, dt] = xcorg(pki(pidx)*1e3/fs, pki(nidx)*1e3/fs, .1, 50);
    pol = atan2(sum(xc(dt>0)), sum(xc(dt<0)))/(pi/4) - 1;
    if abs(pol)<.25
      error('Could not determine polarity based on timing information');
    end
    opts.polarity = sign(pol);
  elseif isnan(opts.polarity)
    plusamp = mean(amp(amp>0));
    negamp = -mean(amp(amp<0));
    if plusamp > 1.2*negamp
      opts.polarity = 1;
    elseif negamp > 1.2*plusamp
      opts.polarity = -1;
    else
      error('Could not determine polarity based on amplitude information');
    end
  end
  if opts.polarity>0
    okpol = datf(pki)>0;
  else
    okpol = datf(pki)<0;
  end
end

idx = find(okpol & usei>opts.nsamp(1) & usei+opts.nsamp(2)<=length(datf));
dt = [-opts.nsamp(1):opts.nsamp(2)];
T = length(dt);
N = length(idx);
spk.waveforms = zeros(N, T);
usei = usei(idx);
for n=1:N
  spk.waveforms(n,:) = datf(usei(n)+dt);
end
spk.amplitude = amp(idx);
spk.spiketimes = usei/fs;
spk.Fs = fs;
spk.threshT = opts.nsamp(1)+1;
if isempty(opts.polarity)
  spk.threshV = [-thrv thrv];
elseif opts.polarity>0
  spk.threshV = [-inf thrv];
elseif opts.polarity<0
  spk.threshV = [-thrv Inf];
else
  spk.threshV = [-thrv thrv]; % This shouldn't happen
end

if ~isempty(opts.oversamp)
  spk.waveforms = upsample(spk.waveforms', opts.oversamp)';
  spk.threshT = opts.nsamp(1)*opts.oversamp + 1;
  spk.Fs0 = fs;
  spk.Fs = opts.oversamp*fs;
end

spk.opts = opts;

