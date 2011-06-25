function scatter2png(basefn,nn,printfn)
% SCATTER2PNG(basefn,nn,printfn) plots 60 pages of scatter plots from files
% named by substituting values in nn for %i in basefn, saving the result
% in printfn (substituting the page number for %i)
k=1;
for n=nn
  fprintf(2,'Loading %i\n',n);
  scat{k} = load(sprintf(basefn,n),'-ascii');
  k=k+1;
end


for hw=0:59
  cr=hw2crd(hw);
  fprintf(2,'Plotting page %i/%i CR=%i\n',hw+1,60,cr);
  scatter1(scat,150,cr);
  print('-opengl','-dpng','-r100',sprintf(printfn,cr));
end
     