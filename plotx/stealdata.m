function [xx,yy,zz] = stealdata
% STEALDATA  Extract data from a graph
%    [xx,yy] = STEALDATA waits for a mouse click on any figure,
%    and returns the data for the plot series clicked.
%    [xx,yy,zz] = STEALDATA returns z-data as well.

lineh = findobj(0,'type','line'); N=length(lineh);
oldfcn = cell(1,N);
for n=1:N
  oldfcn{n} = get(lineh(n),'buttondownfcn');
  set(lineh(n),'buttondownfcn',@stealdata_clickline);
end

setappdata(0,'stealdata__h',[]);
f=gcf;
setappdata(0,'stealdata__f',f);
uiwait(f);
h = getappdata(0,'stealdata__h');
setappdata(0,'stealdata__h',[]);

for n=1:N
  set(lineh(n),'buttondownfcn',oldfcn{n});
end

if ~isempty(h)
  xx=get(h,'xdata');
  yy=get(h,'ydata');
  if nargout>=3
    zz=get(h,'zdata');
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stealdata_clickline(h,x)
setappdata(0,'stealdata__h',h);
uiresume(getappdata(0,'stealdata__f'));
