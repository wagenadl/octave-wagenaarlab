function recalcshifts
% RECALCSHIFTS - Reposition all texts placed with SHIFTEDTEXT after change.
%    After a change in figure size or axis limits, texts placed with
%    SHIFTEDTEXT will not be at their defined positions any more.
%    This function repositions them for the current figure.
%    It also repositions all ticks placed with COMPOSITETICKS.

% SHIFTEDTEXTs
hh = findobj(gcf,'type','text');
for h=hh(:)'
  if isappdata(h,'shiftedtext_data')
    dat = getappdata(h,'shiftedtext_data');
    ax = get(h,'parent');
    [xi,yi] = oneinch(ax);
    set(h,'position',[dat(1) + dat(3)*xi, dat(2) + dat(4)*yi]);
  end
end

% SPACEDTEXTs
for h=hh(:)'
  if isappdata(h,'spacedtext_data')
    dat = getappdata(h,'spacedtext_data');
    ax = get(h,'parent');
    [xi,yi] = oneinch(ax);
    bbox=[inf inf -inf -inf]; % x0 y0 x1 y1, in data coord
    N=length(dat);
    for n=5:N
      uni = get(dat(n),'unit');
      set(dat(n),'unit','data');
      switch get(dat(n),'type')
	case 'text'
	  xywh = get(dat(n),'extent');
	  xyxy = [xywh(1:2) xywh(1:2)+xywh(3:4)];
	case 'line'
	  xx = get(dat(n),'xdata');
	  yy = get(dat(n),'ydata');
	  xyxy = [min(xx) min(yy) max(xx) max(yy)];
	otherwise
	  xyxy = [inf inf -inf -inf];
	  ;
      end
      set(dat(n),'unit',uni);
      bbox(1) = min(bbox(1),xyxy(1));
      bbox(2) = min(bbox(2),xyxy(2));
      bbox(3) = max(bbox(3),xyxy(3));
      bbox(4) = max(bbox(4),xyxy(4));
    end
    x=dat(1); y=dat(2); dx=dat(3); dy=dat(4);
    if dx>0
      x=bbox(3);
    elseif dx<0
      x=bbox(1);
    end
    if dy>0
      y=bbox(4);
    elseif dy<0
      y=bbox(2);
    end
    set(h,'position',[x + dx*xi, y + dy*yi]);
  end
end

% SHIFTEDPLOT
hh = findobj(gcf,'type','line');
for h=hh(:)'
  if isappdata(h,'shiftedplot_data')  
    dat = getappdata(h,'shiftedplot_data');
    ax = get(h,'parent');
    [xi,yi] = oneinch(ax);
    set(h,'xdata', dat{1} + xi*dat{3}, ...
	'ydata', dat{2} + yi*dat{4});
  end

end

% ARROWHEADs with 'lines' style
for h=hh(:)'
  if isappdata(h,'arrowhead_data')
    dat = getappdata(h,'arrowhead_data');
    x=dat(1); y=dat(2); ang=dat(3); l=dat(4:6); w=dat(7);
    ar = arrowhead_calc(x,y,ang,l,w);
    set(h,'xdata',[ar.xr ar.x0 ar.xl],'ydata',[ar.yr ar.y0 ar.yl]);
  end
end

% ARROWHEADs with 'open' or 'solid' style
hh = findobj(gcf,'type','patch');
for h=hh(:)'
  if isappdata(h,'arrowhead_data')
    dat = getappdata(h,'arrowhead_data');
    x=dat(1); y=dat(2); ang=dat(3); l=dat(4:6); w=dat(7);
    ar = arrowhead_calc(x,y,ang,l,w);
    set(h,'xdata',[ar.xr ar.x0 ar.xl ar.x1],'ydata',[ar.yr ar.y0 ar.yl ar.y1]);
  end
end
