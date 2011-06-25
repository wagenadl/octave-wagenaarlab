function scatter2x3(times,chs,reps,maxt,nreps,crs) 
% SCATTER4x4(times,chs,reps,maxt,nreps,crs) plots 2x3 raster
% plots, of CRs mentioned in crs (11..88 style).
% TIMES are the arrival times of spikes, in ms, relative to
% latest trigger.
% CHS are the channel numbers, idem.
% REPS are the trigger numbers, idem.
% MAXT is the window width in ms.
% NREPS is the number of repeats to process.
%
% Here's some perl to create the data from spikedump output:
%
% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; 
%   ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; 
%   print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'
%
% And here's how to plot part of the result:
%
% scatter2x3(tmp(:,1)*1000,tmp(:,2),tmp(:,5),80,200,[21,22,23,24,25,26])

% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'

  for n=1:6
    hw=cr12hw(crs(n))
    ti = times(find(chs==hw));
    re = reps(find(chs==hw));
    subplot(2,3,n);
    plot(ti,re,'.','MarkerSize',3);
    axis([-10,maxt+10,-2,nreps+3]);
    title(sprintf('Electrode CR %i',crs(n)));
  end
  
  set(gcf,'PaperPosition',[0.25 0.25 10.5 8]);
  set(gcf,'PaperUnits','inches');
  set(gcf,'PaperPositionMode','manual');
  set(gcf,'PaperType','usletter');
  set(gcf,'PaperOrientation','landscape');
  set(gcf,'InvertHardCopy','off');
  
%  h=axes('position',[0 1 1 1.001]);
%  t=text('Global title');
%  set(t,'Units','inches');
%  set(t,'Position',[1 -0.1]);
  % print -Pquad -dpsc2