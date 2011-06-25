function crosshairs(hh)
fig = get(hh(1),'parent');
for h=hh(:)'
  axes(h);
  hld=ishold;
  hold on
  p=plot(nan,nan,'r+');
  if hld==0
    hold off
  end
  setappdata(h,'crosshairs_h',p);
end

xywh{1} = get(hh(1),'position');
xywh{2} = get(hh(2),'position');
xywh_ = get(fig,'position');
for k=1:2
  for m=1:2
    for l=1:2
      xywh{k}(l*2+m-2) = xywh{k}(l*2+m-2) * xywh_(2+m);
    end
  end
end
setappdata(fig,'crosshairs_hh',hh);
setappdata(fig,'crosshairs_xywh',xywh);
set(fig,'windowbuttonmotionfcn',@crosshairs_redraw);
set(fig,'pointershapecdata',zeros(16,16)+nan);

function crosshairs_redraw(f,x)
hh=getappdata(f,'crosshairs_hh');
xy=get(f,'currentpoint');
xywh=getappdata(f,'crosshairs_xywh');
if inrect(xy,xywh{1}) 
  xy = fig2ax(xy,hh(1));
elseif inrect(xy,xywh{2})
  xy = fig2ax(xy,hh(2));
else
  xy = [nan nan];
end
if str2double(version('-release'))>=0
  for h=hh(:)'
    p = getappdata(h,'crosshairs_h');
    set(p,'xdata',xy(1));
    set(p,'ydata',xy(2));
  end
end
if isnan(xy)
  set(f,'pointer','arrow');
else
  set(f,'pointer','crosshair');
end
