function pbar(p,xx,y0,dy,dyt,tenplus)
% PBAR(p,xx,y0,dy,dyt) plots a brace bar from between XX(1) and XX(2)
% if P<=.05, and plots *s over it. Brace bar is placed at y = Y0+[0 DY],
% with stars at y = Y0+DYT.
str = pstars(p);
if nargin>=6 & tenplus & isempty(str) & p<=.1
  str='+';
end
if ~isempty(str)
  l=line([xx(1) xx(1) xx(2) xx(2)],[0 dy dy 0]+y0); set(l,'color','k');
  t=text(mean(xx),y0+dyt,str);
  set(t,'horizontala','center');
  if str=='+'
    set(t,'verticala','base');
  end
end
