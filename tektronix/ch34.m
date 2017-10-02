function ch34(ofn)

%unix('setosc ":acq:state stop"');

p3.curv = [];
while isempty(p3.curv)
  try 
    fprintf(1,'Reading channel 3...\n');
    p3 = readosc(3);
  catch
    fprintf(1,'Failed to read channel 3, trying again\n');
  end
end


p4.curv = [];
while isempty(p4.curv)
  try 
  fprintf(1,'Reading channel 4...\n');
    p4 = readosc(4);
  catch
    fprintf(1,'Failed to read channel 4, trying again\n');
  end
end

tt = p3.tt;
y3 = p3.yy;
y4 = p4.yy;
fprintf(1,'Saving...\n');
save(ofn,'y3','y4','tt','p3','p4');

figure(1); clf
[ax,p3,p4]=plotyy(tt,y3,tt,y4);
xlabel 'Time (s)'
ylabel 'Voltage (V)'
t=title(ofn);
set(p3,'color','r');
set(p4,'color','k');
%set(ax(1),'color','k');
%set(ax,'xcol','w');
set(ax(1),'ycol','r');
set(ax(2),'ycol','k');
%set(gcf,'color','k');
%set(t,'color','w');
set(ax,'xlim',[min(tt) max(tt)]);
set(gcf,'paperu','in')
set(gcf,'paperp',[1 1 8 6])
%print('-dpng',[ ofn '.png'])

fprintf(1,'OK\n');

%unix('setosc ":acq:state run"');
