function pbarx(p,xx,y0,dy,dyt)
% PBAR(p,xx,y0,dy,dyt) plots a brace bar from between XX(1) and XX(2)
% if P<=.05, and [rints the p-value over it. 
% Brace bar is placed at y = Y0+[0 DY], with text at y = Y0+DYT.
if p<=.05
  l=line([xx(1) xx(1) xx(2) xx(2)],[0 dy dy 0]+y0); set(l,'color','k');
  t=text(mean(xx),y0+dyt,sprintf('%.3f',p));
  set(t,'horizontala','center');
end
