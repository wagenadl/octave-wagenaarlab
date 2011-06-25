function scatter60log(spks,binsize_ms,linbins,logbins)
% SCATTER60LOG(spks,binsize_ms, linbins,logbins) plots scatter plots
% of all channels in a single graph, using colors to label columns and
% plot symbols for rows. The y-axis represents trial numbers.
% Data must be as for scatter1.
trials=max(spks(:,5));
len=linbins+logbins;
logedges=[0:len];
linedges=log2lin(logedges,binsize_ms,linbins);
for hw=0:59
  cr=hw2crd(hw);
  r=mod(cr,10); 
  c=floor(cr/10);
  cols=[ 1 0 0; 1 .8 .0; 0 .4 0; 0 1 0; ...
	 0 0 1; .5 .6 1; .7 0 .7; 1 .3 1 ];
  syms='ox+*sdv^';
  idx=find((spks(:,2)==hw) & ...
           (spks(:,1)<(log2lin(len,binsize_ms,linbins)/1000)));
  a=plot(lin2log(spks(idx,1)*1000,binsize_ms,linbins), ...
         spks(idx,5)+(mod(r,2)/3-1/6),syms(c),'MarkerSize',4);
  set(a,'Color',cols(r,:));
  hold on
end
y1=trials+2;
y2=trials+3.5;
x1=len/10;
a=text(x1/10,y1,'Columns'); set(a,'Color',[0 0 0]);
for c=1:8
  a=plot(c*x1,y1,syms(c)); set(a,'Color',[0 0 0]);
  a=text(c*x1+x1/10,y1,sprintf('%i',c)); set(a,'Color',[0 0 0]);
end
a=text(x1/10,y2,'Rows'); set(a,'Color',[0 0 0]);
for r=1:8
  a=plot(r*x1,y2+(mod(r,2)/3)-1/6,'.','MarkerSize',20); 
  set(a,'Color',cols(r,:));
  a=text(r*x1+x1/10,y2,sprintf('%i',r)); set(a,'Color',cols(r,:));
end  
hold off

set(gca,'XTick',logedges(1:5:end));
k=1;
for i=[1:5:(len+1)]
  lbl{k}=sprintf('%.0f',linedges(i));
  k=k+1;
end
set(gca,'XTickLabel',lbl');
a=axis; axis([0 len 0 (trials+5)]);
xlabel('Time (ms) - note logarithmic quality');
ylabel('Trial number');
return

% Following fns copied from hist60log.m

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
