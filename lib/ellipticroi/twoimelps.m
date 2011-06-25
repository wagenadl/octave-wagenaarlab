function [el1,el2] = twoimelps(img1,img2,ttl,oldelps)
% [el1,el2] = TWOIMELPS(img1,img2) lets the user draw ellipses over two
% images IMG1 and IMG2, and returns when a [Done] button is clicked.
% TWOIMELPS(...,ttl) specifies a title string for the window
% TWOIMELPS(figh) uses existing figure.

if nargin<3 | isempty(ttl)
  ttl='';
else
  ttl=[ttl ': '];
end

if nargin==1
  figh = img1;
  hh = get(figh,'children');
else
  figh=gcf;
  hh = twoimagebw(img1,img2);
end

if nargin>=4
  setappdata(hh(1),'ellipses',oldelps{1});
  setappdata(hh(2),'ellipses',oldelps{2});
end

xywh = get(figh,'position');
clk = uicontrol(figh,...
    'style','pushbutton',...
    'position',[.47*xywh(3),.007*xywh(4),.06*xywh(3),.04*xywh(4)],...
    'string','Done',...
    'callback',@tie_done);
imageellipses(1,0);
setappdata(figh,'tie_done',0);
fprintf(1,'Drag LEFT to create/move ellipses, drag RIGHT to reshape, click MIDDLE to delete.\nClick [Done] when done, or close to cancel...\n');
set(figh,'numbertitle','off');
set(figh,'name',sprintf('%sAdd or modify ellipses...',ttl));
done=0;
while ~done
  uiwait(1);
  try    
    done=getappdata(figh,'tie_done');
  catch
    done=2;
  end
end

if done==1
  el1 = getappdata(hh(1),'ellipses');
  el2 = getappdata(hh(2),'ellipses');
  
  set(figh,'name',sprintf('%s%i + %i = %i ellipses defined\n',ttl,size(el1,2),size(el2,2),size(el1,2)+size(el2,2)));
  delete(clk);
  for k=1:2
    cc=get(hh(k),'children');
    set(cc,'buttondownfcn',[]);
  end
  set(hh,'buttondownfcn',[]);
else
  el1 = [];
  el2 = [];
end
fprintf(1,'%i + %i = %i ellipses defined.\n',size(el1,2),size(el2,2),size(el1,2)+size(el2,2));
return

function tie_done(h,x)
setappdata(gcbf,'tie_done',1);
uiresume(gcbf);
return
