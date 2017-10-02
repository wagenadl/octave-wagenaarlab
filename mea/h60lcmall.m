%spks={};
%i=1;
%for cr=[12 14 16 22 43 44 54 57 65 66 67 77]
%  cr
%  spks{i}=load(sprintf('3480+23-%i.lenient.scat',cr),'-ascii');
%  i=i+1;
%end

figure
1
subplot(1,2,1);
hist60logcmp(spks,1,25,1);
axis([0 25 11 29]);
2
subplot(1,2,2);
hist60logcmp(spks,1,25,1);
axis([0 25 31 49]);

set(gcf,'PaperPosition',[0.25 0.25 8 10.5]);
set(gcf,'PaperUnits','inches');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperType','usletter');
set(gcf,'PaperOrientation','portrait');
print -dpsc2 h60l-1.ps

figure
1
subplot(1,2,1);
hist60logcmp(spks,1,25,1);
axis([0 25 51 69]);
2
subplot(1,2,2);
hist60logcmp(spks,1,25,1);
axis([0 25 71 89]);

set(gcf,'PaperPosition',[0.25 0.25 8 10.5]);
set(gcf,'PaperUnits','inches');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperType','usletter');
set(gcf,'PaperOrientation','portrait');
print -dpsc2 h60l-2.ps

