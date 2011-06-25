function [xyxy,polyh] = defpoly(axh,nn)
% DEFPOLY - User interface for defining a polygon
%    xyxy = DEFPOLY starts user interaction for defining a polygon on the
%    current axes.
%    xyxy = DEFPOLY(axh) works on the specified axes.
%    The user adds points to the polygon with the left mouse button,
%    delets the last point using the middle button, and completes the
%    polygon using the right button, at which point the function returns.
%    [xyxy, polyh] = DEFPOLY leaves the polygon visible on the figure.

if nargin<1 | isempty(axh)
  axh=gca;
end

if nargin<2
  cel='';
  pre='';
else
  cel=sprintf('{%i}',nn);
  pre='    ';
end

bfn=get(axh,'buttondownfcn');
chh=get(axh,'children');
figh=get(axh,'parent');
ptr=get(figh,'pointer');
bfns=get(chh,'buttondownfcn');
if ~iscell(bfns);
  bfns={bfns};
end

axes(axh);
hold on
polyh=plot([nan],[nan],'r');

setappdata(axh,'xyxy',[]);
setappdata(axh,'polyh',polyh);
set(axh,'buttondownfcn',@defpoly_click);
set(chh,'buttondownfcn',@defpoly_click);

set(figh,'pointer','crosshair');
uiwait(figh);
set(figh,'pointer',ptr);

xyxy=[];
%try
  xyxy = getappdata(axh,'xyxy');
  set(axh,'buttondownfcn',bfn);
  for n=1:length(chh)
    set(chh(n),'buttondownfcn',bfns{n});
  end
  if nargout<2
    delete(polyh);
    clear polyh
  end
  if nargout<1
    fprintf(1,'%sxyxy%s = [ \n',pre,cel);
    for k=1:size(xyxy,1)
      fprintf(1,'%s    %g %g\n',pre,xyxy(k,:));
    end
    fprintf(1,'%s  ];\n',pre);
  end
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function defpoly_click(h,x)
tp = get(h,'type');
if strcmp(tp,'axes')
  axh = h;
else
  axh = get(h,'parent');
end
figh = get(axh,'parent');
try

xyxy = getappdata(axh,'xyxy');
polyh = getappdata(axh,'polyh');

xy = get(axh,'currentpoint');
but = get(figh,'selectiontype');

xy = xy(1,1:2);
stop=0;
switch but
  case 'normal' % Left mouse button
    xyxy = [xyxy; xy];
  case 'extend' % Middle mouse button
    if ~isempty(xyxy)
      xyxy = xyxy(1:end-1,:);
    end
  case 'alt'
    if ~isempty(xyxy)
      xyxy = [xyxy; xyxy(1,:)];
    end
    stop=1;
  otherwise
    return
end

setappdata(axh,'xyxy',xyxy);
set(polyh,'xdata',xyxy(:,1),'ydata',xyxy(:,2));

if stop
  uiresume(figh);
end

catch
uiresume(figh)
lasterr
end
