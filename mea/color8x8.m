function color8x8(Z,lims,cbar)
% COLOR8x8(z, lims) creates a imagesc of the 60 or 64 channel MEA data Z,
% plotted in MEA shape. Optional argument lims specifies min and
% max values (these are plotted invisibly in 9,1 and 9,2).

tbl=zeros(9,9); tbl=tbl.*nan;
for c=1:8
  for r=1:8
    hw=cr2hw(c,r);
    if hw<length(Z)
      tbl(r,c)=Z(hw+1);
    end
  end
end

if nargin<2
  lims=[];
end
if nargin<3
  cbar=1;
end

pcolor(tbl);
set(gca,'XTick',[1.5:8.5]);
set(gca,'YTick',[1.5:8.5]);
set(gca,'XTickLabel',[1:8]);
set(gca,'YTickLabel',[1:8]);
set(gca,'ydir','reverse');
xlabel('C'); ylabel('R');
if ~isempty(lims)
  caxis(lims);
end
if cbar
  colorbar
end

c=get(gca,'ylabel');
set(c,'rota',-90);
set(c,'verticala','top');
%set(c,'posi',[.45,5]);
