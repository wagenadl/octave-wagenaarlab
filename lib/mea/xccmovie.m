function xccmovie(cor,num,nb,dt,crs,fn)
k=1;
for n=num
  n
  plotxcorchans(cor{k},nb,dt,crs);
  print('-dpng','-r300','-opengl',sprintf(fn,n));
  k=k+1;
end
