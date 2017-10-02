%% LOAD
[v,t] = loadephys('/home/wagenaar/mnt/da2/plb/lb/110325/2.1/110325_2.1_Pd-Pv_5.escope');

%% DETECT
% Automatic detection of appropriate phase, 4x oversampling for improved
% temporal resolution, initial alignment on peak rather than threshold
% crossing.
spikes = ss_detectspike(v, t, 'polarity',0, 'oversamp', 4, ...
    'nsamp', [20 30], 'usepeak', 1);
figure(1);
ss_overlayclust(spikes, 'oversamp', 5, 'ybins', 500, 'darker', 2);
% 'oversamp' for SS_OVERLAYCLUST adds visual density. It has nothing to do
% with the oversampling in SS_DETECTSPIKES.

%% ALIGNMENT
spikes = ss_dejitter(spikes, spikes.Fs/1e3);
figure(2); 
ss_overlayclust(spikes, 'oversamp', 5, 'ybins', 500, 'darker', 2);

%% BASELINE SUBTRACTION
spikes.waveforms = detrend(spikes.waveforms', 'constant')';

%% OUTLIER REMOVAL
spikes = ss_oversampledoutliers(spikes);

%% SPIKE SORTING
spikes = ss_kmeans(spikes);
spikes = ss_energy(spikes);
spikes = ss_aggregate(spikes);

%% PLOT FINAL RESULTS
figure(3);
ss_overlayclust(spikes, 'oversamp', 5, 'ybins', 500);

%% PLOT OUTLIERS
figure(4);
ss_overlayclust(spikes, 'oversamp', 5, 'ybins', 500, ...
    'selection', 0, 'darker', 2);

%% OPTIONALLY, ASSIGN OUTLIERS TO NEAREST CLUSTER
out = ss_subset(spikes, 'cluster', 0);
out = ss_assign(out, spikes, 2);
figure(3); cm = getappdata(gca,'colormap');
figure(5);
ss_overlayclust(out, 'oversamp', 5, 'ybins', 500, 'cmap', cm);
% This demonstrates that there was a good reason that these spikes were
% deemed outliers. Still, this could be useful in some circumstances.

figure(6);
plot(spikes.spiketimes, jitter(spikes.hierarchy.assigns,.5), 'x', 'markersize', 2);
xlabel 'Time (s)'
ylabel 'Cluster'
