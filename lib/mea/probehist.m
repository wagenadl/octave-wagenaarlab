function probehist(spks,cr,binsize_ms,binsize_trials)
% PROBEHIST(spks,cr,binsize_ms,binsize_trials) plot color coded
% histograms of spike activity following (and just prior to) a
% stimulus. The plot is binned into columns of BINSIZE_MS
% milliseconds, and into rows of BINSIZE_TRIALS trials. Unlike
% hist60log and friends, this function plots data for only one
% channel, and does not use logarithmic representation for large
% times.
% SPKS must be a matrix loaded from meabench:bytrial output.
% SPKS may also be a cell array of such matrices, in which case
% grey rows are left between entries. 

hw=cr12hw(cr);
myspks=zeros(0,2);
greys=zeros(0,1);
if (iscell(spks))
  offset=0;
  for i=1:length(spks)
    nowidx=find(spks{i}(:,2)==hw & spks{i}(:,5)>=1);
    nowspks=spks{i}(nowidx,[1 5]);
    trials=max(nowspks(:,2));
    trials=binsize_trials*floor(trials/binsize_trials);
    nowidx=find(nowspks(:,2) <= trials);
    nowspks(:,2)=nowspks(:,2) + offset;
    myspks=cat(1,myspks,nowspks(nowidx,:));
    greys=cat(1,greys,offset+trials);
    offset=offset+trials+binsize_trials;
  end
else
  nowidx=find(spks(:,2)==hw & spks{i}(:,5)>=1);
  myspks=spks(nowidx,[1 5]);
end

trials=max(myspks(:,2));
myspks(:,1)=myspks(:,1)*1000; % convert from seconds to ms.
tmin=binsize_ms*floor(min(myspks(:,1))/binsize_ms);
tmax=max(myspks(:,1));

normtime = floor((myspks(:,1)-tmin)/binsize_ms);
normtrial = floor((myspks(:,2)-1)/binsize_trials);
greys=floor(greys/binsize_trials);

maxntime=max(normtime)+1;
maxntrial=max(normtrial)+1;
moretime=[0:maxntime];
moretrial=[0:maxntrial];
whos
normtime=cat(1,normtime,moretime',zeros(length(moretrial),1)+maxntime+1);
normtrial=cat(1,normtrial,zeros(length(moretime),1)+maxntrial+1,moretrial');
whos

xtab=crosstab(normtime,normtrial);
mi=min(min(xtab)); ma=max(max(xtab));
cc=colormap;
for g=greys'
  g
  xtab(:,g+1)=mi-(ma-mi)*2./length(cc);
end
cc(1,:)=.8; colormap(cc);
pcolor(xtab');
colorbar

xtick=get(gca,'XTick');
set(gca,'XTick',xtick);
set(gca,'XTickLabel',xtick*binsize_ms+tmin);
ytick=get(gca,'YTick');
set(gca,'YTick',ytick);
set(gca,'YTickLabel',ytick*binsize_trials);

tmin
xtick
