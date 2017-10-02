INITIME = 1000; % Use 1000 seconds for first pass
TIMESTEP = 500; % Sort rest in blocks of 500 s
MEMORYTIME = 1000; % Use 1000 s of memory

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

%% INITIAL SORTING
inispk = ss_dropresults(ss_subset(spikes, 'time', 0, INITIME));
inispk = ss_oversampledoutliers(inispk);
inispk = ss_kmeans(inispk);
inispk = ss_energy(inispk);
inispk = ss_aggregate(inispk);
spikes.hierarchy.assigns=zeros(size(spikes.spiketimes));
spikes.hierarchy.assigns(inispk.selected) = inispk.hierarchy.assigns;

t_end = max(spikes.spiketimes);
for t0=INITIME:TIMESTEP:t_end
  nxtspk = ss_dropresults(ss_subset(spikes, 'time', t0, t0+TIMESTEP));
  inispk = ss_subset(spikes, 'time', t0-MEMORYTIME, t0);
  nxtspk = ss_assign(nxtspk, inispk, 3);
  spikes.hierarchy.assigns(nxtspk.selected) = nxtspk.hierarchy.assigns;
end

figure(3);
ss_overlayclust(spikes, 'oversamp', 5, 'ybins', 500, 'darker', 2);
cm = getappdata(gca,'colormap');

figure(4);
tt0 = [INITIME:TIMESTEP:t_end]; T=length(tt0);
subplot(1,T+1,1);
ss_overlayclust(ss_subset(spikes, 'time', 0, INITIME), ...
    'oversamp', 5, 'ybins', 500, 'darker', 2, 'cmap', cm);
title 'Initial'
a=axis;
for t=1:T
  subplot(1,T+1,t+1)
  ss_overlayclust(ss_subset(spikes, 'time', tt0(t), tt0(t)+TIMESTEP), ...
      'oversamp', 5, 'ybins', 500, 'darker', 2, 'cmap', cm);
  title(sprintf('%g s -- %g s',tt0(t),tt0(t)+TIMESTEP));
  axis(a);
end

figure(6);
plot(spikes.spiketimes, jitter(spikes.hierarchy.assigns,.5), 'x', 'markersize', 2);
xlabel 'Time (s)'
ylabel 'Cluster'
