function hist60(spks,binsize_ms,nbins)
% HIST60(spks,binsize_ms, ) plots color coded post-stimulus
% histograms of 60 channels in a single graph
edges=[0:binsize_ms:(nbins*binsize_ms)];
nonexist=[11 18 81 88 10:10:80 19:10:79];
vals=zeros(88,length(edges));
for hw=0:59
  cr=hw2crd(hw);
  idx=find(spks(:,2)==hw);
  vv=hist(spks(idx,1)*1000,edges);
%  whos
  vals(cr,:)=vv;
end
vals(1:88,length(edges))=0;
vals=vals/max(spks(:,5));
vals(nonexist,:)=-max(max(vals))/100;
pcolor(edges,[1:88],vals);
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
