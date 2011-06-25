function scatter8x8(times,chs,reps,maxt,nreps,lg) 
% SCATTER8x8(times,chs,reps,maxt,nreps) plots 8x8 raster plots.
% SCATTER8x8(times,chs,reps,maxt,nreps,1) plots 8x8 raster plots with
% axis labeling.
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
% scatter8x8(tmp(:,1),tmp(:,2),tmp(:,5),.080,200)

% perl -e '$pri=0; $t0=0; $r=0; while (<>) { /^#/ and next; chomp; ($t,$c,$h,$w) = split; ($t0,$r)=($t,$r+1) if $pri; $pri = $c==60; print $t-$t0," $c $h $w $r\n" if $c<60 && ($t-$t0>.0005); }'

if nargin<6
  lg=0;
end

clf

  for c=0:59
    ti = times(find(chs==c));
    re = reps(find(chs==c));
    if ~isempty(ti)
      if lg>0
	subplot(8,8,hw2cr(c));
      else
	cr=hw2crd(c);
	c=floor(cr/10); % 1..8
	r=mod(cr,10);   % 1..8
	axes('position',[ (c-1)/8, (8-r)/8, 1/8, 1/8]);
      end
      plot(ti,re,'.','MarkerSize',1);
      axis([0,maxt,0,nreps]);
      if lg==0
	set(gca,'xtick',[0:maxt/10:maxt]);
	if  cr ~= 87
	  set(gca,'xticklabel',[]);
	end
	if cr ~= 21
	  set(gca,'ytick',[]);
	end
      end
    end
  end
