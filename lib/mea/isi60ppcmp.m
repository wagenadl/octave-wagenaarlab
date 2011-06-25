function isi60pp(spks,binsize_ms,prebins,postbins, pre_ms, post_ms, chs)
% ISI60PPCMP(spks,binsize_ms, prebins,postbins,pre_ms,post_ms, chs) 
% makes 60xK ISI plots in a single graph.
% Horizontal axis is time post stimulus, vertical axis is ISI from
% previous spike on same channel.
% PRE_MS, POST_MS are the number of ms recorded pre, post stim - 
% used to distinguish post from next pre.
% CHS is optional, specifies a list of CRs to print. If absent, all
% channels are printed.
% SPKS must be a cell array of "bytrial" data. Cells are plotted in
% different colors.
if nargin<7
  chs=[12:17 21:28 31:38 41:48 51:58 61:68 71:78 82:87];
end

cols='rbrb';

cells=length(spks);
for c=1:cells
  ctrials(c)=max(spks{c}(:,5));
end
ctrials
trials=max(ctrials);


for y=1:length(chs)
  cr=chs(y)
  hw=cr12hw(cr);
  for c=1:cells
    c
    idx=find(spks{c}(:,2)==hw);
    spknow=spks{c}(idx,[1 5]);
    idx=find(spknow(:,1) >= post_ms/1000);
    spknow(idx,1) = spknow(idx,1) - ((post_ms+pre_ms)/1000);
    spknow(idx,2) = spknow(idx,2) + 1;
    maxtri=max(spknow(:,2));
    b=[1 -1];
    a=[1 0];
    for tri=1:maxtri
      idx=find(spknow(:,2) == tri);
      tms=filter(b,a,spknow(idx,1));
      spknow(idx,3)=1./tms;
    end
    maxfrq=max(spknow(:,3));
    plot(spknow(:,1)*1000,  ...
         y +.05+(c-1)/cells + (.9/cells)*spknow(:,3)/maxfrq, ...
         sprintf('%s.',cols(c)),'MarkerSize',1);
     hold on
   end
end
set(gca,'YTick',[1:length(chs)]+.5);
set(gca,'YTickLabel',chs);
xlabel('Time post stimulus (ms)');
ylabel('Channel (CR) and trial');
axis([(-prebins*binsize_ms) (postbins*binsize_ms) 1 (1+length(chs))]);
hold off;
return
