function [x,y]=ungraph(img,xsc,ysc)
% UNGRAPH - Try to take apart a data graph
%    [x,y] = UNGRAPH(img,xsc,ysc) uses user interaction to find a graph
%    and its data points in the image IMG and returns scaled coordinates
%    of clicked points.
f=figure; clf
try
unhide
catch
end
axes('position',[.01 .01 .98 .95]);
h=imagesc(img);
title('Click origin...');
str.h = h;
str.data = zeros(0,2);
setappdata(f,'ungraph',str);
set(h,'buttondownfcn',@ug_clickorigin);
uiwait(f);
str=getappdata(f,'ungraph');
close(f);
str.data(:,1) = (str.data(:,1) - str.origin(1)) / (str.xedge - str.origin(1));
str.data(:,2) = (str.data(:,2) - str.origin(2)) / (str.ytop - str.origin(2));
x = str.data;
if nargin>=2
  x(:,1) = x(:,1)*xsc;
end
if nargin>=3
  x(:,2) = x(:,2)*ysc;
end
if nargout>1
  y=x(:,2);
  x=x(:,1);
end

function ug_clickorigin(h,x)
str=getappdata(gcbf,'ungraph');
xy=get(gca,'currentpoint');
xy=xy(1,1:2);
if strcmp(get(gcbf,'selectiontype'),'alt')
  rbbox;
  xy1=get(gca,'currentpoint');
  xy1=xy1(1,1:2);
  if (xy1(1)-xy(1)).^2 + (xy1(2)-xy(2)).^2 < 5
    axis tight
  else
    axis([sort([xy1(1) xy(1)]) sort([xy1(2) xy(2)])]);
  end
else
  str.origin = xy;
  setappdata(gcbf,'ungraph',str);
  set(str.h,'buttondownfcn',@ug_clickright);
  title('Click right edge of x-axis');
end

function ug_clickright(h,x)
str=getappdata(gcbf,'ungraph');
xy=get(gca,'currentpoint');
xy=xy(1,1:2);
if strcmp(get(gcbf,'selectiontype'),'alt')
  rbbox;
  xy1=get(gca,'currentpoint');
  xy1=xy1(1,1:2);
  if (xy1(1)-xy(1)).^2 + (xy1(2)-xy(2)).^2 < 5
    axis tight
  else
    axis([sort([xy1(1) xy(1)]) sort([xy1(2) xy(2)])]);
  end
else
  str.xedge = xy(1);
  setappdata(gcbf,'ungraph',str);
  set(str.h,'buttondownfcn',@ug_clicktop);
  title('Click top edge of y-axis');
end

function ug_clicktop(h,x)
str=getappdata(gcbf,'ungraph');
xy=get(gca,'currentpoint');
xy=xy(1,1:2);
if strcmp(get(gcbf,'selectiontype'),'alt')
  rbbox;
  xy1=get(gca,'currentpoint');
  xy1=xy1(1,1:2);
  if (xy1(1)-xy(1)).^2 + (xy1(2)-xy(2)).^2 < 5
    axis tight
  else
    axis([sort([xy1(1) xy(1)]) sort([xy1(2) xy(2)])]);
  end
else
  str.ytop = xy(2);
  setappdata(gcbf,'ungraph',str);
  set(str.h,'buttondownfcn',@ug_clickdata);
  title('Click data points (0)');
end

function ug_clickdata(h,x)
if strcmp(get(gcbf,'selectiontype'),'extend')
  title 'All done'
  uiresume(gcbf)
  return
end

str=getappdata(gcbf,'ungraph');
xy=get(gca,'currentpoint');
xy=xy(1,1:2);
if strcmp(get(gcbf,'selectiontype'),'alt')
  rbbox;
  xy1=get(gca,'currentpoint');
  xy1=xy1(1,1:2);
  if (xy1(1)-xy(1)).^2 + (xy1(2)-xy(2)).^2 < 5
    axis tight
  else
    axis([sort([xy1(1) xy(1)]) sort([xy1(2) xy(2)])]);
  end
else
  str.data = [str.data; xy];
  title(sprintf('Click data points (%i)',size(str.data,1)));
  setappdata(gcbf,'ungraph',str);
end
