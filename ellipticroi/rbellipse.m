function xyxy = rbellipse(h, xy)
% xyxy = RBELLIPSE(h) allows the user to drag an ellipse onto the specified
% axes, much like RBBOX.
% xyxy = RBELLIPSE works in current axes.
% xyxy = RBELLIPSE(h, xy) specifies a first point other than 'currentpoint'.
% Return value: xyxy = [firstx,firsty,lastx,lasty], in axes coordinates.

if nargin<1
  h=gca;
end

xy2 = get(h,'currentpoint'); xy2=xy2(1,1:2);

if nargin<2
  xy=xy2;
end

xyxy = [xy(1) xy(2) xy2(1) xy2(2)];
setappdata(h,'rbellipse_pos',[xyxy]);
rbe_draw(h)

f=get(h,'parent');
set(f,'windowbuttonmotionfcn',@rbe_motion)
set(f,'windowbuttonupfcn',@rbe_up)

uiwait(f);

xyxy = getappdata(gca,'rbellipse_pos');
set(f,'windowbuttonmotionfcn',[]);
set(f,'windowbuttonup',[]);

return

function rbe_draw(h)
xyxy = getappdata(h,'rbellipse_pos');
xyxy([1 3])=sort(xyxy([1 3]));
xyxy([2 4])=sort(xyxy([2 4]));
r = rectangle('position',[xyxy(1:2) xyxy(3:4)+1-xyxy(1:2)],...
    'curvature',[1 1],'edgecolor',[1 .5 0],'linew',2);
setappdata(h,'rbellipse_rect',r);
return

function rbe_undraw(h)
r = getappdata(h,'rbellipse_rect');
if r
  %%fprintf(1,'undraw: %g\n',r);
  delete(r)
  setappdata(h,'rbellipse_rect',0);
end
return

function rbe_redraw(h)
xyxy = getappdata(h,'rbellipse_pos');
xyxy([1 3])=sort(xyxy([1 3]));
xyxy([2 4])=sort(xyxy([2 4]));
r = getappdata(h,'rbellipse_rect');
set(r,'position',[xyxy(1:2) xyxy(3:4)+1-xyxy(1:2)]);
return

function rbe_motion(f,x)
h = get(f,'currentaxes');
xyxy = getappdata(h,'rbellipse_pos');
xy = get(h,'currentpoint');
%fprintf(1,'Motion: f=%g h=%g xy=(%.1f,%.1f) xy_=(%.1f,%.1f)\n',...
%    f,h,xy,xy_(1,1:2));
xyxy(3)=xy(1,1); xyxy(4)=xy(1,2);
rbe_redraw(h);
setappdata(h,'rbellipse_pos',xyxy);
return

function rbe_up(f,x)
%% fprintf(1,'Up!\n');
rbe_motion(f,x)
h = get(f,'currentaxes');
rbe_undraw(h)
uiresume(f)
