function plotroleclusts(y)
% PLOTROLECLUSTS(y) plots all clusters in the cell matrix y, which
% must be one CR element of the return value of rolecluster.
% The background cluster is drawn black, dotted line. The non-role
% cluster is drawn yellow, dotted line. Other clusters are drawn in 
% various colors with regular lines.
cols='rgbcm';
stypt='*';
stycir='-';
h=ishold;
plotclust(y{1}.w0,y{1}.h0,y{1}.ww,y{1}.hh,y{1}.wh,'k*','k-');
hold on;
if y{2}.n > 0
  plotclust(y{2}.w0,y{2}.h0,y{2}.ww,y{2}.hh,y{2}.wh,'yo','y:');
end

for r=3:length(y)
  if y{r}.n > 0
    c=floor(mod(r-3,5))+1;
    sp=sprintf('%s',cols(c));
    sc=sprintf('%s%s',cols(c),stycir);
    plotclust(y{r}.w0,y{r}.h0,y{r}.ww,y{r}.hh,y{r}.wh,sp,sc,...
	      sprintf('%i',r-3));
  end
end
if h==0
  hold off
end

