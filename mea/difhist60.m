function difhist60(spks1,spks2,binsize_ms,nbins,t0_ms)
% HIST60(spks1,spks2,binsize_ms,nbins,t0) plots color coded post-stimulus
% histograms of 60 channels in a single graph. Spikes before t0 are 
% dropped.
if nargin<5
  t0_ms=0;
end
edges=[0:binsize_ms:(nbins*binsize_ms)];
nonexist=[11 18 81 88 10:10:80 19:10:79];
vals=zeros(88,length(edges));
for hw=0:59
  cr=hw2crd(hw);
  idx=find(spks1(:,2)==hw & spks1(:,1)*1000>t0_ms);
  vv=hist(spks1(idx,1)*1000,edges);
  idx=find(spks2(:,2)==hw & spks2(:,1)*1000>t0_ms);
  ww=hist(spks2(idx,1)*1000,edges);
%  whos
  vals(cr,:)=vv-ww;
end
vals(1:88,length(edges))=0;
vals=vals/max(spks1(:,5));
%vals(nonexist,:)=-max(max(vals))/100;
pcolor(edges,[1:88],vals);
shading flat
colormap(jet(200));
colorbar
