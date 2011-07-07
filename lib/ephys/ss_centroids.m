function [cc, rms, dcc] = ss_centroids(spk)
% SS_CENTROIDS - Calculate centroids for sorted spikes
%    cc = SS_CENTROIDS(spikes) calculates centroids for a given spike
%    structure. Clusters that have no spikes in them yield NaN centroids.
%    [cc, rms] = SS_CENTROIDS(spikes) also returns the RMS size of each
%    cluster.
%    [cc, rms, dcc] = SS_CENTROIDS(spikes) als returns the std.dev. in each
%    position

Q=max(spk.hierarchy.assigns);
[N T]=size(spk.waveforms);
cc = zeros(Q,T) + nan;

if nargout>=2
  rms = zeros(Q,1) + nan;
  if nargout>=3
    dcc = zeros(Q,T) + nan;
  end
end

for q=1:Q
  idx = find(spk.hierarchy.assigns==q);
  K = length(idx);
  if K>0
    wv = spk.waveforms(idx,:);
    cc(q,:) = mean(wv);
    if nargout>=2
      dc = mean((wv-repmat(cc(q,:),[K 1])).^2);
      rms(q) = sqrt(mean(dc));
      if nargout>=3
	dcc(q,:) = sqrt(dc);
      end
    end
  end
end

