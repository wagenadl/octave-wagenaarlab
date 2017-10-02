function tmpl = spiketemplate(tt, yy, idx, varargin)
% SPIKETEMPLATE - Extract template for spike matching
%    tmpl = SPIKETEMPLATE(tt, yy, idx), where IDX is the corresponding field
%    from DUMPSPIKE or a selection of elements thereof, produces a template
%    for spike detection. It is assumed that TT is measured in seconds.
%    SPIKETEMPLATE(..., key, value) specified additional parameters:
%      halfwidth: template halfwidth in ms (default: 3).
%   SPIKETEMPLATE(yy, tt, ...) or SPIKETEMPLATE(yy, fs, ...) also works.

kv = getopt('halfwidth=3', varargin);

[tt, yy, fs] = normalizespikedetargs(tt, yy);

T = length(tt);
L = round(kv.halfwidth*fs/1e3);

idx = idx(find(idx>L & idx<=T-L)); % Drop spikes near edges

N = length(idx);

tmpl = zeros(2*L+1, N);
for n=1:N
  tmpl(:, n) = yy(idx(n)+[-L:L]);
end

tmpl = mean(tmpl, 2);
