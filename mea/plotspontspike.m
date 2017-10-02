function plotspontspike(fn)
% PLOTSPONTSPIKE(fn) plot a 1x88 spike rasters with spikes shifted vertically
% by random small amounts to not overlap them to much.
% It also plots, in a separate figure, the aggregate firing rate as a 
% function of time, as well as a power spectrum.
spont=loadspksnoc(fn);
id=find(spont.channel<60);
maxt=max(spont.time(id));

figure(1);
plot(spont.time(id),hw2crd(spont.channel(id))+rand(1,length(id))*.8-.4,...
    '.','markersize',1);
set(gca,'ytick',sort([12 [21:10:71] 82 17 [28:10:78] 87]));
xlabel 'Time (s)'
ylabel 'Recording channel (CR)'

for cr=[11 18 81 88 [10:10:90] [19:10:89]]
  r=rectangle('position',[0 cr-.5 maxt+1 1]);
  set(r,'facecolor',[.8 .8 .8]); 
  set(r,'edgecolor',[.8 .8 .8]);
end
for cr=[11:88];
  r=line([0 maxt+1], [cr-.5 cr-.5]);
  set(r,'color',[.8,.8,.8]);
end

axis([0, maxt+1, 11, 88]);

figure(2);

ff=10;
tt=[0:(1/ff):maxt+(1/ff)];
hh=hist(spont.time,tt);
subplot(2,1,1);
bar(tt,hh*ff);
axis tight;
xlabel 'Time (s)'
ylabel 'All channel cumul rate (Hz)'

subplot(2,1,2);
pmtm(detrend(hh),3.5,[],ff);
