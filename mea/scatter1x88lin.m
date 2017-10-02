function scatter1x88lin(dat,ttl)
% SCATTER1x88LIN(dat,ttl) plots the spike rate data in dat (produced by
% spikerate with -l), and plots it as 1x88 graphs.

if nargin<2
  ttl='';
end

maxt=max(dat(:,1))/25000
dt=(dat(22,1)-dat(21,1))/25000;

cols = 'rygcbm';
hold off;
mmm=max(max(dat(:,2:end)))/2;
lmm=log10(mmm); il=floor(lmm); bs=ceil(10^(lmm-il));
mmm=bs*10^il;
for cr=88:-1:11
  hw=cr12hw(cr);
  if hw>=0 & hw<60
    plot(dat(:,1)/25000/60,cr + dat(:,hw+2)/mmm, ...
	sprintf('%s-',cols(rem(cr,6)+1)),'LineWidth',1); 
    axis([0 maxt/60 10 89]);
    hold on;
  end
end
orient landscape;
xlabel('Time (minutes)')
ylabel('Channel (CR)')
title(sprintf('Activity %s in %g ms segments - scale is %g s^{-1}',ttl,dt*1000,mmm/dt));
