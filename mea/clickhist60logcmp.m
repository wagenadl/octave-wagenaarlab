function clickhist60logcmp(spksorig,spksbytrial,binsize_ms,linbins,logbins,symsize)
% CLICKHIST60LOGCMP(spksorig,spksbytrial, binsize_ms,linbins,logbins,symsize)
% plots scatter plots of all 60 channels for all spike collections
% given.
% SPKSORIG should be a cell array of spike files.
% SPKSBYTRIAL should be a cell array of bytrial output files.
% See also clickhist60log and hist60logcmp.
% SYMSIZE, if given specifies the plot symbol size.

if nargin<6
  symsize=1;
end

cols=[0 0 0; 1 0 0; .1 .1 1; 0 .7 0; .8 .8 0; 0 .8 .9];

len=linbins+logbins;
N=length(spksbytrial);
trials=0;
for i=1:N
  spks{i}=load(spksbytrial{i},'-ascii');
  trials=max([trials max(spks{i}(:,5))]);
end
logedges=[0:len];
linedges=log2lin(logedges,binsize_ms,linbins);
width=linedges(2:end)-linedges(1:len);
nonexist=[11 18 81 88 10:10:80 19:10:89];
vals=zeros(89,len);
vals([2:2:89],:)=.5;
vals(nonexist,:)=1;
pcolor(logedges(1:len),[1:89],vals);

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

shading flat
cmap(1,[1:3])=1;
cmap(2,[1:3])=.95;
cmap(3,[1:3])=.8;
colormap(cmap);

points=zeros(4,0);

hold on;
N=length(spks);
for hw=0:59 
  cr=hw2crd(hw);
  for i=1:N
    idx=find(spks{i}(:,2)==hw);
    xx=lin2log(spks{i}(idx,1)*1000,binsize_ms,linbins)';
    yy=cr +.05+(.9/N)*(i-1+spks{i}(idx,5)/trials)';
    zz=spks{i}(idx,6)';
    ww=0.*zz + i;
    nowpts=[xx; yy; zz; ww];
    a=plot(xx,yy,'k.','MarkerSize',symsize);
    set(a,'Color',cols(1+floor(mod(i-1,length(cols))),:));
    points=cat(2,points,nowpts);
  end
end
hold off;

clickmanyspikes(spksorig,points);

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
