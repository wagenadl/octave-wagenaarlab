function ch12(ofn)

%unix('setosc ":acq:state stop"');

p1.curv = [];
while isempty(p1.curv)
  try 
    fprintf(1,'Reading channel 1...\n');
    p1 = readosc(1);
  catch
    fprintf(1,'Failed to read channel 1, trying again\n');
  end
end


p2.curv = [];
while isempty(p2.curv)
  try 
  fprintf(1,'Reading channel 2...\n');
    p2 = readosc(2);
  catch
    fprintf(1,'Failed to read channel 2, trying again\n');
  end
end

tt = p1.tt;
y1 = p1.yy;
y2 = p2.yy;
fprintf(1,'Saving...\n');
save(ofn,'y1','y2','tt','p1','p2');

figure(1); clf
[ax,p1,p2]=plotyy(tt,y1,tt,y2);
xlabel 'Time (s)'
ylabel 'Voltage (V)'
t=title(ofn);
set(p1,'color','r');
set(p2,'color','k');
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
