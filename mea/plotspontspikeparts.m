function plotspontspike(fn,winstart,winwidth)
% PLOTSPONTSPIKE(fn,winstart,winwidth) plot 1x88 spike rasters with 
% spikes shifted vertically by random small amounts to not overlap
% them to much.
% winstart is a vector of window start times, in seconds; winwidth is the
% width of such a window. Only spikes falling within one of the windows are
% plotted.
spont=loadspksnoc(fn);
id=find(spont.channel<60);
maxt=max(spont.time(id));

figure(1); clf
W=length(winstart);
for w=1:W
  axes('position',[(w-1)/W*.94+.05 .1 .85/W .85]);
  plot(spont.time(id),hw2crd(spont.channel(id))+rand(1,length(id))*.8-.4,...
      '.','markersize',1);
  set(gca,'ytick',sort([12 [21:10:71] 82 17 [28:10:78] 87]));
  xlabel 'Time (s)'
  if w==1
    ylabel 'Recording channel (CR)'
  end
  axis([winstart(w) winstart(w)+winwidth 11 88]);
  
  for cr=[11 18 81 88 [10:10:90] [19:10:89]]
    r=rectangle('position',[0 cr-.5 maxt+1 1]);
    set(r,'facecolor',[.8 .8 .8]); 
    set(r,'edgecolor',[.8 .8 .8]);
  end
  for cr=[11:88];
    r=line([0 maxt+1], [cr-.5 cr-.5]);
    set(r,'color',[.8,.8,.8]);
  end

end

