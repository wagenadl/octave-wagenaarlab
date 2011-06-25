function el = eldrag_center(el,npts,varargin)
% ELDRAG_CENTER   Lets the user drag an ellipse around
%    el = ELDRAG_CENTER(el) lets the user drag the given ellipse around
%    in the current axes, and finally returns the new shape.
%    el = ELDRAG_CENTER(el,npts) specifies number of points to draw.
%    el = ELDRAG_CENTER(el,npts,key1,val1,...) specifies additional
%    plot parameters.

if getappdata(gcf,'mousemove__recurse')
  return
end

h=gca;
hld=ishold;
hold on
setappdata(h,'eldrag_h',[]);
[xy0,xy1] = mousemove(@eldc,el,npts,varargin{:});
delete(getappdata(h,'eldrag_h'));
setappdata(h,'eldrag_h',[]);
if getappdata(h,'mousemove_significant')
  el.x0 = el.x0 + xy1(1)-xy0(1);
  el.y0 = el.y0 + xy1(2)-xy0(2);
end
if ~hld
  hold off
end

function eldc(h, xy0, xy1, el, npts, varargin)
if getappdata(h,'mousemove_significant')
  delete(getappdata(h,'eldrag_h'));
  el.x0 = el.x0 + xy1(1)-xy0(1);
  el.y0 = el.y0 + xy1(2)-xy0(2);
  setappdata(h,'eldrag_h',elplot_xyrra(el,npts,varargin{:}));
end
