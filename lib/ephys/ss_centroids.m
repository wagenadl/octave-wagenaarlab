function [cc, dcc] = ss_centroids(spk)
% SS_CENTROIDS - Calculate centroids for sorted spikes
%    cc = SS_CENTROIDS(spikes) calculates centroids for a given spike
%    structure. Clusters that have no spikes in them yield NaN centroids.
%    [cc, dcc] = SS_CENTROIDS(spikes) also returns the RMS size of each
%    cluster.

Q=max(spk.hierarchy.assigns);
[N T]=size(spk.waveforms);
cc = zeros(Q,T) + nan;

if nargout>1
  dcc = zeros(Q,1) + nan;
end

for q=1:Q
  idx = find(spk.hierarchy.assigns==q);
  K = length(idx);
  if K>0
    wv = spk.waveforms(idx,:);
    cc(q,:) = mean(wv);
    if nargout>1
      dcc(q) = sqrt(mean(sum((wv-repmat(cc(q,:),[K 1])).^2)));
    end
  end
end

