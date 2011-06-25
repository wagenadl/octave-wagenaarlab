function histsomelog(spks,binsize_ms,linbins,maxtime_ms,chs)
% HISTSOMELOG(spks,binsize_ms, linbins,maxtime_ms, chs) plots color coded 
% post-stimulus histograms of some channels in a single graph.
% CHS is an array of CR channel numbers to be plotted.
logbins=floor(lin2log(maxtime_ms,binsize_ms,linbins)) - linbins;
len=linbins+logbins;
trials=max(spks(:,5));
logedges=[0:len];
linedges=log2lin(logedges,binsize_ms,linbins);
width=linedges(2:end)-linedges(1:len);
nch=length(chs);
%vals=zeros(nch*2,len);
%for n=1:nch
%  cr=chs(n);
%  hw=cr12hw(cr);
%  idx=find(spks(:,2)==hw);
%  if length(idx)>0
%    vv=histc(lin2log(spks(idx,1)*1000,binsize_ms,linbins),logedges);
%    xi=reshape(vv(1:len),1,len);
%    vals(n*2,:)=xi ./ width;
%  else
%    vals(n*2,:)=0;
%  end
%end
%vals=vals/trials;
%vals(nch*2+1,:)=0;
%pcolor(logedges(1:len),[1:.5:(nch+1)],vals);
%
%shading flat
%cc=[0:.005:1];
%gg=1-2*cc; gg(gg<0)=0; gg=gg.^1.5;
%bb=0*cc; bb(1)=1;
%rr=2-2*cc; rr(rr>1)=1; rr=(rr+rr.^1.5)/2;
%cmap=[rr',gg',bb'];   
%%cmap(1,:)=.8;
%%cmap(2,:)=1;
%cmap(1,:)=1;
%colormap(cmap);
%colorbar

%hold on;

for n=1:nch
  cr=chs(n);
  hw=cr12hw(cr);
  idx=find(spks(:,2)==hw);
  cr=hw2crd(hw);
  plot(lin2log(spks(idx,1)*1000,binsize_ms,linbins), ...
       n +.05+.9*spks(idx,5)/trials,'k.','MarkerSize',6);
  hold on;
end

set(gca,'XTick',logedges(1:5:end));
set(gca,'YTick',[1.5:(nch+.5)]);
set(gca,'YTickLabel',chs);
k=1;
for i=[1:5:(len+1)]
  lbl{k}=sprintf('%.0f',linedges(i));
  k=k+1;
end
set(gca,'XTickLabel',lbl');
a=axis; axis([0 (linbins+logbins) 1 (nch+1)]);
xlabel('Time (ms) - note logarithmic quality');
ylabel('Channel (CR)');
title('Average spike count, normalized to spikes/ms');

hold off;
return

function tt=lin2log(t,binsize,linbins)
  t0=binsize*linbins;
  tt=t/binsize;
  idx=find(t>=t0);
  tt(idx)=linbins+log(t(idx)/t0)/log(1+1/linbins);
return

function t=log2lin(tt,binsize,linbins)
  t0=binsize*linbins;
  t=tt*binsize;
  idx=find(t>=linbins);
  t(idx)=t0*(1+1/linbins).^(tt(idx)-linbins);
return
