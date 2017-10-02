function rasterbook(infns,outbase,pre_ms,post_ms,showpre_ms,showpost_ms,cols,labels)
% RASTERBOOK(infns,outbase,pre_ms,post_ms,showpre_ms,showpost_ms,cols,labels) 
% produces 60 graphs of spike rasters. 
% Spikes are loaded from the specified input files. Graphs
% are annotated by input filenames, or, if specified, by LABELS.
% If COLS is specified, it should contain color triplets for each
% file. If it is not given, or is empty, red and blue are used alternatingly.
% It is recommended to clean the spikes using cleanspks before using
% this function.

N=length(infns);
if nargin<8
  labels=infns;
end
if nargin<7
  cols=[];
end
if nargin<5
  showpre_ms=pre_ms;
end
if nargin<6
  showpost_ms=post_ms;
end

if isempty(cols)
  cols=zeros(N,3);
  cols([2:2:N],3)=1; % Blue
  cols([1:2:N],1)=1; % Red
end

trials=zeros(1,N);
maxtri=zeros(1,N);
tms=cell(1,N);
tri=cell(1,N);
hww=cell(1,N);
base=0;
for n=1:N
  fprintf(2,'Loading file %i/%i: "%s"\n',n,N,infns{n});
  spks=loadspksnoc(infns{n});
  trinow=floor(spks.time*1000 / (pre_ms+post_ms));
  tmsnow=spks.time*1000 - trinow*(pre_ms+post_ms) - pre_ms;
  idx=find(tmsnow>=-showpre_ms & tmsnow<=showpost_ms);
  tms{n}=tmsnow(idx);
  tri{n}=trinow(idx)+base;
  hww{n}=spks.channel(idx);
  trials(n)=max(trinow)+1;
  base=base+trials(n);
  maxtri(n)=base;
end

figure(1);
for hw=0:59
  clf
  cr=hw2crd(hw);
  idx=find(hww==hw);
  plot(tms(idx),tri(idx),'b.','Markersize',2);
  axis([-pre_ms post_ms 0 base+1]);
  set(gca,'ytick',[0 maxtri(1:(N-1))]);
  set(gca,'yticklabel',labels);
  xlabel 'Time (ms)'
  print('-dpsc2',[ outbase '-' num2str(cr) '.ps']);
end