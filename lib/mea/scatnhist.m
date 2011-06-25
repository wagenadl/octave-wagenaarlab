function scatnhist(srcs,maxt,crs, histhei,bindt,skipbins) 
% SCATNHIST(srcs,maxt,crs,histhei,bindt,skipbins) plot raster
% plots and histograms, of the CR in crs (11..88 style).
% SRCS must be a cell array of Nx5 matrices with columns:
% 1: arrival times of spikes, in seconds, relative to latest trigger.
% 2: the channel numbers, idem.
% 3: unused, spike height
% 4: unused, spike width
% 5: trigger number
% Trigger numbers are supposed to start from 1 for each source.
% Trigger 0 is ignored.
% MAXT is the window width in ms.
% CRS is a CR channel number to display
% HISTHEI is the height of the histogram areas, in units of raster
% lines
% BINDT is the width of histogram bins, in ms.
% SKIPBINS is an initial number of bins to skip for maximum calculation.
%
% Here's some perl to create the data from spikedump output:
%
% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; 
%   ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; 
%   print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'
%
% And here's how to plot part of the result:
%
% scatter2x3({tmp},80,21,20,2);

% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'

hw=cr12hw(crs);
hold off;
cols='rbrbrbrbrbrbrbrbrbrbrbrb';

edges = [0:bindt:maxt];
nsrc = length(srcs);

trials = max(srcs{1}(:,5));
dy = trials + 10 + histhei;
offset = histhei;
histo=zeros(nsrc,length(edges));

for k=1:nsrc
  k
  [xx yy ] = size(srcs{k});
  if xx>0
    idx = find(srcs{k}(:,2)==hw);
    ti = srcs{k}(idx,1) * 1000;
    re = srcs{k}(idx,5);
    idx = find(re~=0);
    if length(idx)>0
      ti = ti(idx);
      re = re(idx);
      plot(ti,re + offset,sprintf('o%s',cols(k)),'MarkerSize',2);
      hold on;
      whos
      histo(k,:) = histc(ti',edges);
    end
    offset = offset + dy;
  end
end

maxmax=max(max(histo(:,(skipbins+1):end),[],2))/2;
logmm=log10((maxmax+.0001));
ilog=floor(logmm);
flog=logmm-ilog;
fmm=ceil(10^flog);
maxmax=10^ilog * fmm;

for k=1:nsrc
  plot(edges+(bindt/2),histo(k,:)*histhei/maxmax + (k-1)*dy, ...
      sprintf('-k'),'LineWidth',2); 
end

axis([-5,maxt+5,-2,length(srcs)*dy+2]);
title(sprintf('Electrode CR %i',crs));
ytiy=zeros(2*nsrc,1);
for k=1:nsrc
  ytiy(k*2-1) = (k-1)*dy;
  ytiy(k*2) = (k-1)*dy+histhei;
  ytiv{k*2-1} = '0';
  ytiv{k*2} = sprintf('%g',maxmax*1000/bindt/(trials+.00001));
end
set(gca,'YTick',ytiy);
set(gca,'YTickLabel',ytiv);
set(gca,'TickDir','in');
set(gca,'YGrid','on');

set(gcf,'PaperPosition',[0 0 6 6]);
set(gcf,'PaperSize',[6 6]);
set(gcf,'PaperUnits','inches');
set(gcf,'PaperPositionMode','manual');

