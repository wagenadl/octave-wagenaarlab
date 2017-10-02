function scatter2x3many(srcs,maxt,crs) 
% SCATTER2x3many(srcs,maxt,crs) plots 2x3 raster
% plots, of CRs mentioned in crs (11..88 style).
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

  N=length(crs);

  for n=1:N
    hw=cr12hw(crs(n));
    subplot(ceil(N/2),2,n);
    hold off;
    offset=0;
    cols='rbrbrbrbrbrbrbrbrbrbrbrb';
    n
    for k=1:length(srcs)
      k
%      [xx yy ] = size(srcs{k})
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
    end
%    keyboard
    axis([-10,maxt+10,-2,offset+3]);
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