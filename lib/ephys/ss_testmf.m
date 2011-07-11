load('ana/110602-3-spikes.mat');

cc = ss_centroids(spks{2});
idx = find(~isnan(cc(:,1)));
templates = cc(idx,:)';
spiketimes = spks{2}.spiketimes * 25e3;



fid = fopen('ana/110602_3-A2.bin', 'rb');
trace = fread(fid,[1 inf], 'int16');
fclose(fid);

trc = trace(1e6+1:2e6);
spkti = spiketimes-1e6;
idx = find(spkti>0 & spkti<=1e6);
spkti = spkti(idx);
spkcl = spks{2}.hierarchy.assigns(idx);

rr = ss_matchedfilters(templates, trace(1e6:end), spiketimes);

[T K] = size(rr);
for k=1:K
  tp(:,k) = conv(trc', flipud(rr(2:end,k)));
end
