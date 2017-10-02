function somexcor(fnbase,num,nb,dt,chs)
% SOMEXCOR(fnbase,num,nb,dt) plots a selection of crosscorrellograms from 
% the data in filenames fnbase (with elements of num replacing %i).
% nb is number of bins per half graph.
% dt is time width of bin.
% chs is the channel selection (a 4x2 matrix).
% Example usage:
% 
% somexcor('3464+%i.bf5.ord.50.2.xcor',[2:33],50,2, ...
%          [ 12 13; 14 16; 28 27; 56 57 ]);

% ; 71 81; 35 36; 43 57; 76 17; ...
%   72 84; 75 85; 23 24; 25 34; 22 31; 42 46; 44 45; 61 64 ])
ra=nb-.5;

cols='rgbykmc';

k=1;
for n=num
  fprintf(2,'Loading %i\n',n);
  dat{k}=loadcor(sprintf(fnbase,n));
  fprintf(2,'Normalizing %i\n',n);
  for c=1:64
    for d=1:64
      nor = max(dat{k}{c}{d});
      if nor>0
	dat{k}{c}{d} = dat{k}{c}{d} ./ nor;
      end
    end
  end
  k=k+1;
  whos
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
    shading interp;
    k=k+1;
  end
  title(sprintf('Normalized counts %i-%i',chs(p,1),chs(p,2)));
  xlabel('ISI (ms)');
  ylabel('DIV');
end
