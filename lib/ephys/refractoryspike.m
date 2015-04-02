function spk = refractoryspike(tt, yy, varargin)
% REFRACTORYSPIKE - Spike detection with respect for refractory periods
%   spk = REFRACTORYSPIKE(tt, yy) detects spikes in the signal YY sampled
%   at times TT (measured in seconds).
%
%   Result is a structure with fields:
%      tms - time stamps of the spikes
%      hei - amplitudes of the spikes
%      idx - index into the input vectors.
%      wid - width of spike (measured between zero crossings)
%
%   REFRACTORYSPIKE(yy, tt, key, value, ...) specifies additional parameters:
%      threshold - threshold specified in units of YY. No default.
%      rmsthr - threshold specified in units of estimated RMS noise. Default: 5.
%      trefract - refractory time specified in ms. Default: 10.
%      polarity - polarity of spikes to be detected: 1 for positive, -1 for
%                 negative, 0 for either (default).
%      f_low - low-end frequency for bandpass filtering, in Hz. Default: none.
%      f_high - high-end frequency for bandpass filtering, in Hz. Default: none.
%
%   If (and only if) filtering is applied, the result will have an additional
%   structure hei0 to hold the height before filtering.
%
%   REFRACTORYSPIKE(yy, tt, ...) or REFRACTORYSPIKE(yy, fs, ...) also works.
%   Note that results are formatted for direct use in (I)SELECTSPIKE.

kv = getopt('threshold rmsthr trefract=10 polarity=0 f_low f_high', varargin);
if ~isempty(kv.threshold) && ~isempty(kv.rmsthr)
  error('REFRACTORYSPIKE cannot take both THRESHOLD and RMSTHR');
end
if isempty(kv.threshold) && isempty(kv.rmsthr)
  kv.rmsthr = 5;
end

[tt, yy, fs] = normalizespikedetargs(tt, yy);


if isempty(kv.threshold)
  kv.threshold = rmsnoise(tt, yy)*kv.rmsthr;
else
  kv.threshold = abs(kv.threshold);
end

if ~isempty(kv.f_low) || ~isempty(kv.f_high)
  yy0 = yy;
  if ~isempty(kv.f_low)
    [b, a] = butterhigh1(kv.f_low/fs);
    yy = filtfilt(b, a, yy);
  end
  if ~isempty(kv.f_high)
    [b, a] = butterlow1(kv.f_high/fs);
    yy = filtfilt(b, a, yy);
  end
end

if kv.polarity>=0
  s = dumbspike(tt, yy, kv.threshold);
  
  while 1
    maydrop = find(diff(s.tms) < kv.trefract*1e-3);
    if isempty(maydrop)
      break
    end
    dropwhich = s.amp(maydrop+1)<s.amp(maydrop);
    maydrop = maydrop + dropwhich;
    s.idx(maydrop) = [];
    s.wid(maydrop) = [];
  end  
  
  spk = s;
end

if kv.polarity<=0
  s = dumbspike(tt, yy, -kv.threshold);
  
  while 1
    maydrop = find(diff(s.tms) < kv.trefract*1e-3);
    if isempty(maydrop)
      break
    end
    dropwhich = s.amp(maydrop+1)>s.amp(maydrop);
    maydrop = maydrop + dropwhich;
    s.idx(maydrop) = [];
    s.wid(maydrop) = [];
  end

  if kv.polarity==0
    spk.idx = [spk.idx; s.idx];
    spk.wid = [spk.wid; s.wid];
  else
    spk = s;
  end
end

[spk.idx, ord] = sort(spk.idx);
spk.wid = spk.wid(ord);

spk.amp = yy(spk.idx);
spk.tms = tt(spk.idx);
if ~isempty(kv.f_low) || ~isempty(kv.f_high)
  spk.amp0 = yy0(spk.idx);
end
