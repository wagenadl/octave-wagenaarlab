function spk = refractoryspike(tt, yy, varargin)
% REFRACTORYSPIKE - Spike detection with respect for refractory periods
%   spk = REFRACTORYSPIKE(tt, yy) detects spikes in the signal YY sampled
%   at times TT (measured in seconds).
%
%   Result is a structure with fields:
%      tms - time stamps of the spikes
%      amp - amplitudes of the spikes
%      idx - index into the input vectors.
%      wid - width of spike (measured in seconds between zero crossings)
%
%   REFRACTORYSPIKE(yy, tt, key, value, ...) specifies additional parameters:
%      threshold - threshold specified in units of YY. No default.
%      rmsthr - threshold specified in units of estimated RMS noise. Default: 5.
%      trefract - refractory time specified in ms. Default: 10.
%      polarity - polarity of spikes to be detected: 1 for positive, -1 for
%                 negative, 0 for either (default).
%      f_low - low-end frequency for bandpass filtering, in Hz. Default: none.
%      f_high - high-end frequency for bandpass filtering, in Hz. Default: none.
%      biphasic - if not zero, adds the amplitude of immediately preceding
%                 opposite-polarity peaks
%
%   If (and only if) filtering is applied, the result will have an additional
%   structure amp0 to hold the height before filtering.
%
%   REFRACTORYSPIKE(yy, tt, ...) or REFRACTORYSPIKE(yy, fs, ...) also works.
%   Note that results are formatted for direct use in (I)SELECTSPIKE.

kv = getopt('threshold rmsthr trefract=10 polarity=0 f_low f_high biphasic=0', varargin);
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

s1 = dumbspike(tt, yy, kv.threshold);
s2 = dumbspike(tt, yy, -kv.threshold);

if kv.polarity>=0
  s = s1;
  if kv.biphasic==3
    s = maketriphasic(s, s2);
  elseif kv.biphasic
    s = makebiphasic(s, s2);
  end

  while 1
    maydrop = find(diff(s.tms) < kv.trefract*1e-3);
    if isempty(maydrop)
      break
    end
    dropwhich = s.amp(maydrop+1)<s.amp(maydrop);
    maydrop = maydrop + dropwhich;
    s.tms(maydrop) = [];
    s.amp(maydrop) = [];
    s.idx(maydrop) = [];
    s.wid(maydrop) = [];
  end  

  spk = s;
end

if kv.polarity<=0
  s = s2;
  if kv.biphasic==3
    s = maketriphasic(s, s1);
  elseif kv.biphasic
    s = makebiphasic(s, s1);
  end
  
  while 1
    maydrop = find(diff(s.tms) < kv.trefract*1e-3);
    if isempty(maydrop)
      break
    end
    dropwhich = s.amp(maydrop+1)>s.amp(maydrop);
    maydrop = maydrop + dropwhich;
    s.tms(maydrop) = [];
    s.amp(maydrop) = [];
    s.idx(maydrop) = [];
    s.wid(maydrop) = [];
  end

  if kv.polarity==0
    spk.idx = [spk.idx; s.idx];
    spk.amp = [spk.amp; s.amp];
    spk.tms = [spk.tms; s.tms];
    spk.wid = [spk.wid; s.wid];
  else
    spk = s;
  end
end

[spk.idx, ord] = sort(spk.idx);
spk.tms = spk.tms(ord);
spk.amp = spk.amp(ord);
spk.wid = spk.wid(ord);

if ~isempty(kv.f_low) || ~isempty(kv.f_high)
  spk.amp0 = yy0(spk.idx);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function spk = makebiphasic(spk, tt, yy)
%dt = mean(diff(tt));
%a0 = mean(pol*spk.amp(pol*spk.amp>0))
%w0 = mean(spk.wid(pol*spk.amp>a0))
%di = round(w0/dt);
%for k=1:length(spk.tms)
%  ii = [-di:0]+spk.idx(k);
%  ii = ii(ii>0 & ii<=length(tt));
%  spk.amp(k) = spk.amp(k) + pol*max(-pol*yy(ii));
%end

function spk = makebiphasic(spk, alt)
for k=1:length(spk.tms)
  t0 = spk.tms(k);
  idx = find(alt.tms>t0, 1);
  if ~isempty(idx)
    a = [];
    t1 = alt.tms(idx);
    if t1-t0 < .005
      a(end+1) = alt.amp(idx);
    end
    if idx>1
      t1 = alt.tms(idx-1);
      if t0-t1 < .005
        a(end+1) = alt.amp(idx-1);
      end
    end
    if ~isempty(a)
      spk.amp(k) += max(a)*sign(spk.amp(k));
    end
  end
end

function spk = maketriphasic(spk, alt)
for k=1:length(spk.tms)
  t0 = spk.tms(k);
  idx = find(alt.tms>spk.tms(k), 1);
  if ~isempty(idx)
    a = [];
    t1 = alt.tms(idx);
    if t1-t0 < .005
      a(end+1) = alt.amp(idx);
    end
    if idx>1
      t1 = alt.tms(idx-1);
      if t0-t1 < .005
        a(end+1) = alt.amp(idx-1);
      end
    end
    spk.amp(k) -= sum(a);
  end
end

