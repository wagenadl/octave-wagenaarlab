function plotxcorvsdiv(dat,num,nb,dt,chs)
% PLOTXCORVSDIV(cor,num,nb,dt) plots a selection of crosscorrellograms from 
% the data in cor. cor must have been loaded by loadmanyxcor.
% nb is number of bins per half graph.
% dt is time width of bin.
% chs is the channel selection (a 4x2 matrix).
% Example usage:
% 
% cor=loadmanyxcor('3464+%i.bf5.ord.50.2.xcor',[2:33]);
% plotxcorvsdiv(cor,[2:33],50,2, ...
%               [ 12 13; 14 16; 28 27; 56 57 ]);

ra=nb-.5;

cols='rgbykmc';

k=1;
for n=num
  k=k+1;
end
maxk=k-1;


for p=1:4
  fprintf(2,'Plotting subplot %i\n',p);
  subplot(2,2,p);
  k=1;
  now=zeros(maxk,nb*2);
 % keyboard
  for n=num
    now(k,:) = dat{k}{cr12hw(chs(p,1))+1}{cr12hw(chs(p,2))+1}';
    pcolor([-ra:ra]*dt,num,now);
    colormap(hot);
    colorbar;
    shading flat;
    k=k+1;
  end
  title(sprintf('Normalized counts %i-%i',chs(p,1),chs(p,2)));
  xlabel('ISI (ms)');
  ylabel('DIV');
end
