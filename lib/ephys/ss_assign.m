function spk = ss_assign(spk, master, cutoff)
% SS_ASSIGN - Assign spikes to clusters based on templates
%    spk = SS_ASSIGN(spk, master) assigns spikes in SPK to the nearest
%    cluster defined in MASTER.
%    Distance to centroid is returned as well.
%    spk = SS_ASSIGN(spk, master, cutoff) only assigns spikes with normalized
%    distance less than CUTOFF.
%
%    An alternative would be to normalize the distances by cluster spread,
%    or even better, assign based on Bayesian inference. If I can estimate
%    the likelihood that a given waveform W is produced by a cluster K as
%    p(W|K), then I can calculate p(K|W) = p(W|K) p(K) / p(W).
%    Here I can the number of spikes in cluster K divided by the total
%    number of spikes as p(K), and I can use p(W) = sum_K p(W|K).
%    The trouble is a robust estimate for p(W|K). This is by no means
%    a trivial operation. I could look at each time point in the template
%    separately, and calculate p(W|K) = prod_t p(W_t|K), but in fact the
%    time points are probably strongly correlated, so p(W_t) doesn't 
%    factorize like that. So then I might as well 
if nargin<3
  cutoff=inf;
end

[spk.centroids, spk.cvar] = ss_centroids(master);
[N T]=size(spk.waveforms);

qq = find(~isnan(spk.cvar)); R=length(qq);
spk.hierarchy.assigns = zeros(N,1);
spk.hierarchy.dist = zeros(N,1);
spk.hierarchy.ndist = zeros(N,1);

for n=1:N
  dx = repmat(spk.waveforms(n,:),[R 1]) - spk.centroids(qq,:);
  dx = sum(dx.^2,2);
  [dx, r] = min(dx);
  spk.hierarchy.assigns(n) = qq(r);
  spk.hierarchy.dist(n) = sqrt(dx);
  spk.hierarchy.ndist(n) = spk.hierarchy.dist(n) / spk.cvar(qq(r));
end

spk.hierarchy.assigns(spk.hierarchy.ndist>cutoff) = 0;
