function scatter1(srcs,maxt,crs) 
% SCATTER1(srcs,maxt,crs) plots 2x3 raster
% plots, of the CR in crs (11..88 style).
% srcs must be a cell array of Nx5 matrices with columns:
% 1: arrival times of spikes, in seconds, relative to latest trigger.
% 2: the channel numbers, idem.
% 3: unused, spike height
% 4: unused, spike width
% 5: trigger number
% Trigger numbers are supposed to start from 1 for each source.
% Trigger 0 is ignored.
% MAXT is the window width in ms.
%
% Here's some perl to create the data from spikedump output:
%
% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; 
%   ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; 
%   print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'
%
% And here's how to plot part of the result:
%
% scatter2x3({tmp},80,[21,22,23,24,25,26])

% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'

hw=cr12hw(crs);
hold off;
offset=0;
cols='rbrbrbrbrbrbrbrbrbrbrbrb';
for k=1:length(srcs)
  k
  [xx yy ] = size(srcs{k});
  if xx>0
    idx = find(srcs{k}(:,2)==hw);
    ti = srcs{k}(idx,1) * 1000;
    re = srcs{k}(idx,5);
    idx = find(re~=0);
    ti = ti(idx);
    re = re(idx);
    re = re + offset;
    plot(ti,re,sprintf('.%s',cols(k)),'MarkerSize',2);
    hold on;
    offset = offset + 1 + max(srcs{k}(:,5));
  else
    plot(-100,0);
    offset = offset + 1 + 50;
  end
end
axis([-10,maxt+10,-2,offset+3]);
title(sprintf('Electrode CR %i',crs));
  
set(gcf,'PaperPosition',[0 0 6 6]);
set(gcf,'PaperSize',[6 6]);
set(gcf,'PaperUnits','inches');
set(gcf,'PaperPositionMode','manual');

