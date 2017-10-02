function scatter1xcustom(ifn,ofn,ttl,crs)
% SCATTER1xCUSTOM(ifn,ofn,ttl,crs) loads the ascii file ifn (produced by
% spikerate with -l),
% plots it as 1xN graphs and saves the resulting graphics into ofn.
dat=load(ifn,'-ascii');
cols = 'rbmk';
figure(1); hold off;
k=1;
for cr=crs
  if cr==0
    k=k+1
  else
    hw=cr12hw(cr);
    cr=hw2crd(hw);
    plot(dat(:,1)/25000,k + log(dat(:,hw+2)+1)/5, ...
  	sprintf('%s-',cols(rem(cr,4)+1))); 
    k=k+1;
    axis([-1 1001 .5 (k+.5)]);
    hold on;
  end
end
orient landscape;
xlabel('Time (s)')
ylabel('Channel')
title(sprintf('Activity in 250 ms bins [plotted as y=log(f+1)/5] %s',ttl));
drawnow
print(gcf,'-dpsc2','-r300',ofn);
return

% Example:
% scastter1xcustom('3464+9a.rate','3464+9a.custom.ps','3464+9a', ...
% [75 85 65 66 67 77 87 86 12 32 43 54 36 56 14 16 ...
% 15 33 55 68 ...
% 13 17 21 23 24 25 26 27 28 31 34 35 37 38 41 42 44 45 46 47 48 ...
% 51 52 53 57 58 61 62 63 64 71 72 74 76 78 82 83 84]);
