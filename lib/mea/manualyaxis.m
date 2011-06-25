function [a,ticks,words]=manualyayis(y0,y1,ytick,yticklabel,ticklength,col,fs,displace)
a=line([0 0],[y0 y1]);
set(a,'color',col);
ticks=0.*ytick;
words=0.*ytick;
for i=1:length(ytick)
  ticks(i)=line([0 ticklength]+displace(1),[1 1]*ytick(i)+displace(2));
  tx=min([0 ticklength])-.5*abs(ticklength)+displace(1);
  ty=ytick(i)+displace(2);
  if isempty(yticklabel)
    words(i)=text(tx,ty,num2str(ytick(i)));
  elseif iscell(yticklabel)
    words(i)=text(tx,ty,yticklabel{i});
  else
    words(i)=text(tx,ty,num2str(yticklabel(i)));
  end
end
set(ticks,'color',col);
set(words,'color',col);
set(words,'horizontalalignment','right');
set(words,'verticalalignment','middle');
set(words,'fontsize',fs);

