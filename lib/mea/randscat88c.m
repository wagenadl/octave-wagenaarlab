function p=randscat88c(spks)
% RANDSCAT88c(spks) plots scatter plots of the (spontaneous activity) spikes
% in SPKS. It stacks thin horizontal raster plots for each channel. Within
% each plot, spikes are positioned vertically based on their
% height-over-threshold.
% 
% p = RANDSCAT88c(spks) returns the plot handle.

hei=spks.height./spks.thresh;
zz=min(abs(hei));
hei = hei - zz.*sign(hei);

p=plot(spks.time,hw2crd(spks.channel) + 0.1*hei,'.');
cr=[12:17 21:28 31:38 41:48 51:58 61:68 71:78 82:87];
t0=min(spks.time); t1=max(spks.time);
for y=cr(:)'
  l=line([t0 t1],[y y]);
  set(l,'color',[.7 .7 .7]);
end

set(p,'markersize',2);
xlabel 'Time (s)'
ylabel 'Channel (CR)'
axis tight
set(gca,'ytick',[12 17 21 28 31 38 41 48 51 58 61 68 71 78 82 87]);

