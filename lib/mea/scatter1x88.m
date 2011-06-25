function scatter1x88(ifn,ofn,ttl)
% SCATTER1x88(ifn,ofn,ttl) loads the ascii file ifn (produced by
% spikerate with -l),
% plots it as 1x88 graphs and saves the resulting graphics into ofn.

dat=load(ifn,'-ascii');
cols = 'rbmk';
figure(1); hold off;
for hw=0:59
  cr=hw2crd(hw);
  plot(dat(:,1)/25000,cr + log(dat(:,hw+2)+1)/5, ...
      sprintf('%s-',cols(rem(cr,4)+1))); 
  axis([0 1000 10 89]);
  hold on;
end
orient landscape;
xlabel('Time (s)')
ylabel('Channer (CR)')
title(sprintf('Activity in 250 ms bins [plotted as y=log(f+1)/5] %s',ttl));
drawnow
print(gcf,'-dpsc2','-r300',ofn);