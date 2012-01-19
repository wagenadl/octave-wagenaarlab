function spk = ss_assign(spk, master, cutoff)
% SS_ASSIGN - Assign spikes to clusters based on templates
%    spk = SS_ASSIGN(spk, master) assigns spikes in SPK to the nearest
%    cluster defined in MASTER.
%    Distance to centroid is returned as well.
%    spk = SS_ASSIGN(spk, master, cutoff) only assigns spikes with normalized
%    distance less than CUTOFF.

if nargin<3
  cutoff=inf;
end

[spk.centroids, svar] = ss_centroids(master);
spk.cvar = svar.sw;

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
