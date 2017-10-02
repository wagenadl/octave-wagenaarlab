function spk = templatespike(tt, yy, varargin)
% TEMPLATESPIKE - Spike detection with template-based enhancement
%    spk = TEMPLATESPIKE(tt, yy) detects spikes in the signal YY sampled
%    at time points TT (in seconds).
%
%    spk = TEMPLATESPIKE(tt, yy, key, value, ...) specifies additional 
%    arguments which are passed directly to REFRACTORYSPIKE.
%    Note that for TEMPLATESPIKE, a higher threshold may be appropriate
%    than for REFRACTORYSPIKE, because the template enhancement makes the
%    noise strongly non-Gaussian.
%
%   TEMPLATESPIKE(yy, tt, ...) or TEMPLATESPIKE(yy, fs, ...) also works.
%   Note that results are formatted for direct use in (I)SELECTSPIKE.

[tt, yy, fs] = normalizespikedetargs(tt, yy);

thr = 5*rmsnoise(tt, yy);

% First, find the upgoing spikes
ups = dumbspike(tt, yy, thr);
[dd, ord] = sort(ups.amp);
N = length(ord);
K = 10; % Use topmost K spikes, ...
E = 1;  % ... but leave out the very top E
N0 = max(1, N+1-K-E);
N1 = max(1, N-E);
idx = ups.idx(ord(N0:N1));
uptmpl = spiketemplate(tt, yy, idx);

upy = conv(yy, uptmpl, 'same');

args = varargin;
args{end+1} = 'polarity';
args{end+1} = 1;
ups = refractoryspike(tt, upy, args{:});

% Then, find the downgoing spikes
dns = dumbspike(tt, yy, -thr);
[dd, ord] = sort(-dns.amp);
N = length(ord);
K = 10; % Use topmost K spikes, ...
E = 1;  % ... but leave out the very top E
N0 = max(1, N-K-E);
N1 = max(1, N-E);
idx = dns.idx(ord(N0:N1));
dntmpl = spiketemplate(tt, yy, idx);

dny = conv(yy, -dntmpl, 'same');

args = varargin;
args{end+1} = 'polarity';
args{end+1} = -1;
dns = refractoryspike(tt, dny, args{:});

% Combine results
spk = joinspikes(ups, dns);
