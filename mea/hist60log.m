function hist60log(spks,binsize_ms,linbins,logbins)
% HIST60LOG(spks,binsize_ms, linbins,logbins) plots color coded post-stimulus
% histograms of 60 channels in a single graph
len=linbins+logbins;
trials=max(spks(:,5));
logedges=[0:len];
linedges=log2lin(logedges,binsize_ms,linbins);
width=linedges(2:end)-linedges(1:len);
nonexist=[11 18 81 88 10:10:80 19:10:79];
vals=zeros(88*2,len);
for hw=0:59
  cr=hw2crd(hw);
  idx=find(spks(:,2)==hw);
  if length(idx)>0
    vv=histc(lin2log(spks(idx,1)*1000,binsize_ms,linbins),logedges);
    xi=reshape(vv(1:len),1,len);
    vals(cr*2,:)=xi ./ width;
  else
    vals(cr*2,:)=0;
  end
end
vals=vals/trials;
vals(2*nonexist,:)=-max(max(vals))/100;
vals(2*nonexist-1,:)=-max(max(vals))/100;
vals(89*2-1,:)=0;
pcolor(logedges(1:len),[1:.5:89],vals);

set(gca,'XTick',logedges(1:5:end));
k=1;
for i=[1:5:(len+1)]
  lbl{k}=sprintf('%.0f',linedges(i));
  k=k+1;
end
set(gca,'XTickLabel',lbl');
a=axis; axis([a(1) a(2) 11 89]);
xlabel('Time (ms) - note logarithmic quality');
ylabel('Channel (CR)');
title('Average spike count, normalized to spikes/ms');

shading flat
cc=[0:.005:1];
gg=1-2*cc; gg(gg<0)=0; gg=gg.^1.5;
bb=0*cc; bb(1)=1;
rr=2-2*cc; rr(rr>1)=1; rr=(rr+rr.^1.5)/2;
cmap=[rr',gg',bb'];   
cmap(1,:)=.8;
cmap(2,:)=1;
colormap(cmap);
colorbar

hold on;
for hw=0:59 
  idx=find(spks(:,2)==hw);
  cr=hw2crd(hw);
  plot(lin2log(spks(idx,1)*1000,binsize_ms,linbins), ...
       cr +.1+.4*spks(idx,5)/trials,'k.','MarkerSize',1);
end
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
