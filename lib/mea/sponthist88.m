function y=sponthist88(spks,binsize_ms)
T=max(spks.time);
N=ceil(T*1000 / binsize_ms);
y=zeros(60,N+1);
for c=1:60
  idx = find(spks.channel==c-1);
  y(c,:) = hist(spks.time(idx),T*[0:N]/N);
end
pcolor(y);
shading flat
