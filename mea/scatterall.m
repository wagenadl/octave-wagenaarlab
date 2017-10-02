function scatterall(basefn,nn,printfn)
% SCATTERALL(basefn,nn,printfn) plots ten pages of scatter plots from files
% named by substituting values in nn for %i in basefn, saving the result
% in printfn (substituting the page number for %i)
k=1;
for n=nn
  fprintf(2,'Loading %i\n',n);
  scat{k} = load(sprintf(basefn,n),'-ascii');
  k=k+1;
end


%chs=[12 13 14 15 16 17; 22 23 24 25 26 27; 32 33 34 35 36 37; ...
%     42 43 44 45 46 47; 52 53 54 55 56 57; 62 63 64 65 66 67; ...
%     72 73 74 75 76 77; 82 83 84 85 86 87; ...
%     21 31 41 51 61 71; 28 38 48 58 68 78];
chs = [12 13 14 15; 82 83 84 85; 16 17 86 87; ...
       21 22 23 24; 25 26 27 28; 31 32 33 34; 35 36 37 38; ...
       41 42 43 44; 45 46 47 48; 51 52 53 54; 55 56 57 58; ...
       61 62 63 64; 65 66 67 68; 71 72 73 74; 75 76 77 78 ];
pgs=size(chs,1);
for pg=1:pgs
  fprintf(2,'Plotting page %i/%i\n',pg,pgs);
  scatter2x3many(scat,150,chs(pg,:));
  print('-opengl','-dpng','-r300',sprintf(printfn,pg));
end
     