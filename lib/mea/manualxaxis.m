function [a,ticks,words]=manualxaxis(x0,x1,xtick,xticklabel,ticklength,col,fs,displace)
a=line([x0 x1]+displace(1),[0 0]+displace(2));
set(a,'color',col);
ticks=0.*xtick;
words=0.*xtick;
for i=1:length(xtick)
  ticks(i)=line([1 1]*xtick(i)+displace(1),[0 ticklength]+displace(2));
  tx=xtick(i)+displace(1);
  ty=min([0 ticklength])-.5*abs(ticklength)+displace(2);
  if isempty(xticklabel)
    words(i)=text(tx,ty,num2str(xtick(i)));
  elseif iscell(xticklabel)
    words(i)=text(tx,ty,xticklabel{i});
  else    
    words(i)=text(tx,ty,num2str(xticklabel(i)));
  end
end
set(ticks,'color',col);
set(words,'color',col);
set(words,'horizontalalignment','center');
set(words,'verticalalignment','top');
set(words,'fontsize',fs);

