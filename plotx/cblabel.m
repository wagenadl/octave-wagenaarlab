function h=cblabel(txt)
% CBLABEL(txt) adds a label to the colorbar associated with the current axes.
% h = CBLABEL(...) returns handle to the label.

%%% First, lets find the colorbar
hsub=gca; hfig=gcf;

% Get all colorbars in current figure
cc = get(findall(hfig,'type','image','tag','TMW_COLORBAR'),{'parent'});
C=length(cc);

% Find which one matches our current handle
v=version;
ax=[];
if atoi(v)>=7
  ax = find_colorbar(hsub);
else
  have=0;
  for c=1:C
    ud = get(cc{c},'userdata');
    d = ud.PlotHandle;
    if isequal(d,hsub)
      have=c;
    end
  end
  if have
    ax=cc{have}
  end
end

if ~isempty(ax)
  l = get(ax,'ylabel');
  set(l,'string',txt);
else
  l = nan;
end

if nargout>0
  h = l;
end

return

% Following taken (with modifications) from matlab's "colorbar.m"
%   Copyright 1984-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.10 $  $  $

%----------------------------------------------------%
function hc = find_colorbar(peeraxes)

fig = get(peeraxes,'parent');
ax = findobj(fig,'type','axes');
hc=[];
k=1;
% vectorize
while k<=length(ax) && isempty(hc)
  if iscolorbar(ax(k))
    hax = handle(ax(k));
    if isequal(double(hax.axes),peeraxes)
      hc = ax(k);
    end
  end
  k=k+1;
end
    
%----------------------------------------------------%
function tf=iscolorbar(ax)

if length(ax) ~= 1 || ~ishandle(ax) 
    tf=false;
else
    tf=isa(handle(ax),'scribe.colorbar');
end

