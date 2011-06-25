function scat60pp(spks,binsize_ms,prebins,postbins, pre_ms, post_ms, chs)
% HIST60LOG(spks,binsize_ms, prebins,postbins,pre_ms,post_ms, chs) 
% makes 60 scatter plots in a single graph.
% pre_ms, post_ms are the number of ms recorded pre, post stim - 
% used to distinguish post from next pre.
% chs is optional, specifies a list of CRs to print. If absent, all
% channels are printed.
if nargin<7
  chs=[12:17 21:28 31:38 41:48 51:58 61:68 71:78 82:87];
end

trials=max(spks(:,5));

for y=1:length(chs)
  cr=chs(y);
  hw=cr12hw(cr);
  idx=find(spks(:,2)==hw);
  spknow=spks(idx,[1 5]);
  idx=find(spknow(:,1) >= post_ms/1000);
  spknow(idx,1) = spknow(idx,1) - ((post_ms+pre_ms)/1000);
  spknow(idx,2) = spknow(idx,2) + 1;
  plot(spknow(:,1)*1000,  ...
       y +.05+.9*spknow(:,2)/trials,'k.','MarkerSize',1);
  hold on
end
set(gca,'YTick',[1:length(chs)]+.5);
set(gca,'YTickLabel',chs);
xlabel('Time post stimulus (ms)');
ylabel('Channel (CR) and trial');
axis([(-prebins*binsize_ms) (postbins*binsize_ms) 1 (1+length(chs))]);
hold off;
return
