function filters = ss_matchedfilters(templates, trace, spiketimes)
% SS_MATCHEDFILTERS - Calculate matched filters for spike detection
%    filters = SS_MATCHEDFILTERS(templates, trace) calculates matched
%    filters for spike detection on a single channel. The columns of
%    TEMPLATES (TxK) must be templates of waveforms to be detected.
%    FILTERS (TxK) will contain in its columns the optimal filters to
%    be convolved into the signal trace.
%    TRACE should be (a portion of) the original signal, for the purpose
%    of estimating noise.
%    SS_MATCHEDFILTERS(templates, trace, spiketimes) avoids parts of the
%    trace that contain spikes.

[T, K] = size(templates);

L = length(trace);
W = 10*T;
N = floor(L/W);

trace = reshape(trace(1:N*W),[W,N]); % reshape into short windows

cautioustimes = [spiketimes(:); spiketimes(:)-.8*T; spiketimes(:)+.8*T];

% Determine which windows are contaminated by spikes
spikewin = 1+floor((cautioustimes-1)/W); % these windows contain spikes
spikewin = uniq(sort(spikewin)); % might as well
spikewin = spikewin(spikewin>=1 & spikewin<=N);
use = logical(ones(N,1));
use(spikewin) = 0;

% Keep only clean windows
trace = trace(:,use);

N = size(trace,2);
xc = zeros(T,N);
for n=1:N
  x = xcorr(detrend(trace(:,n)), T, 'unbiased');
  xc(:,n) = x(end-T+1:end);
end

cc = mean(xc,2);

ccf = fft(cc,[],1);
tmplf = fft(templates,[],1);

rrf = zeros(T, K) + i;

for k=1:K
  for l=1:K
    if l~=k
      rrf(:,k) = rrf(:,k) + tmplf(:,k)./(tmplf(:,l).*conj(tmplf(:,l))+ccf);
    end
  end
end

rr = ifft(rrf,[],1);
