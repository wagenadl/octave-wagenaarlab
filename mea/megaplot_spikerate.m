function megaplot_spikerate(fns,spks,colrs,binsize,smooth)

K=length(spks);

dur=zeros(1,K);
rate=cell(1,K);
for k=1:K
  fprintf(2,'Creating histogram %i/%i: %s\n',k,K,fns{k});
  rate{k} = hist(spks{k}.time(find(spks{k}.channel<60)), ...
      [min(spks{k}.time):binsize:max(spks{k}.time)]);
end

x=0;
for k=1:K
  fprintf(2,'Plotting histogram %i/%i: %s\n',k,K,fns{k});
  xx = x + [1:length(rate{k})] * binsize;
  plot(xx,gaussianblur1d(rate{k},smooth),colrs{k});
  hold on
  x = max(xx);
end
