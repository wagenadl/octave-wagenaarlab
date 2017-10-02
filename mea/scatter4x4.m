function scatter4x4(times,chs,reps,maxt,nreps,col0,row0) 
% SCATTER4x4(times,chs,reps,maxt,nreps,col0,row0) plots 4x4 raster
% plots, starting from (col0,row) (counted 1..8).
% TIMES are the arrival times of spikes, in seconds, relative to
% latest trigger.
% CHS are the channel numbers, idem.
% REPS are the trigger numbers, idem.
% MAXT is the window width in seconds.
% NREPS is the number of repeats to process.
%
% Here's some perl to create the data from spikedump output:
%
% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; 
%   ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; 
%   print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'
%
% And here's how to plot the result:
%
% scatter4x4(tmp(:,1),tmp(:,2),tmp(:,5),.080,200,5,5)

% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'

  for c=0:3
    for r=0:3
      hw=cr2hw(col0+c,row0+r);
      ti = times(find(chs==hw));
      re = reps(find(chs==hw));
      subplot(4,4,c+4*r+1);
      plot(ti,re,'.','MarkerSize',1);
      axis([-0.010,maxt+0.010,-2,nreps+3]);
    end
  end
  
  set(gcf,'PaperPosition',[0.25 0.25 10.5 8]);
  set(gcf,'PaperUnits','inches');
  set(gcf,'PaperPositionMode','manual');
  set(gcf,'PaperType','usletter');
  set(gcf,'PaperOrientation','landscape');
  set(gcf,'InvertHardCopy','off');
  
  h=axes('position',[0 1 1 1.001]);
  t=text('Global title');
  set(t,'Units','inches');
  set(t,'Position',[1 -0.1]);
  % print -Pquad -dpsc2