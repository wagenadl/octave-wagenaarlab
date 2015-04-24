function spk = dumbspike(tt, yy, thr)
% DUMBSPIKE - Very basic threshold spike detection
%   spk = DUMBSPIKE(tt, yy, thr) detects spikes in the data YY that exceed
%   the threshold THR.
%
%   If THR is positive, upgoing spikes are detected, if THR is negative,
%   downgoing spikes are detected.
%   The result is a structure with fields:
%      tms - time stamps of the spikes
%      hei - amplitudes of the spikes
%      idx - index into the input vectors.
%      wid - width of spike (measured between zero crossings)
%
%   DUMBSPIKE(yy, tt, ...) or DUMBSPIKE(yy, fs, ...) also works.
%   Note that results are formatted for direct use in (I)SELECTSPIKE.
%
%   DUMBSPIKE really is not very smart, so for most purposes, TEMPLATESPIKE
%   or REFRACTORYSPIKE is more appropriate.

[tt, yy] = normalizespikedetargs(tt, yy);

if thr>0
  [idx, i0, i1, istart, iend] = schmittpeak2(yy, thr, 0);
else
  [idx, i0, i1, istart, iend] = schmittpeak2(-yy, -thr, 0);
end

spk.idx = idx;
spk.tms = tt(idx);
spk.amp = yy(idx);
spk.wid = tt(iend) - tt(istart);
if length(spk.wid)<length(spk.idx)
  spk.wid(end+1) = 0;
end
