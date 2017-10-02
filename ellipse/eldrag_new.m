function el = eldrag_new(npts,varargin)
% ELDRAG_NEW   Lets the user create a new ellipse by dragging
%    el = ELDRAG_NEW lets the user create a new ellipse by dragging in the
%    current axes, and returns the shape.
%    el = ELDRAG_NEW(npts) specifies how many points are to be drawn along
%    the ellipse outline while dragging.
%    el = ELDRAG_NEW(npts,key1,val1,...) specifies additional
%    plot parameters.
%    If the use drags by less than 2 pixels, no ellipse is generated, and
%    [] is returned.


if getappdata(gcf,'mousemove__recurse')
  el=[];
  return
end

h=gca;
hld=ishold;
hold on
setappdata(h,'eldrag_h',[]);
[xy0,xy1] = mousemove(@eldn,npts,varargin{:});
delete(getappdata(h,'eldrag_h'));
setappdata(h,'eldrag_h',[]);
if getappdata(h,'mousemove_significant')
  el = eldn_getshape(xy0,xy1);
else
  el = [];
end
if ~hld
  hold off
end

function eldn(h, xy0, xy1, npts, varargin)
if getappdata(h,'mousemove_significant')
  delete(getappdata(h,'eldrag_h'));
  el = eldn_getshape(xy0,xy1);
  setappdata(h,'eldrag_h',elplot_xyrra(el,npts,varargin{:}));
end

function el = eldn_getshape(xy0,xy1)

xy = (xy0 + xy1) / 2; xy=xy(:)';
ab = abs(xy0 - xy1) / 2; ab=ab(:)';

el.x0=xy(1);
el.y0=xy(2);
el.R=max(ab)*sqrt(2);
el.r=min(ab)*sqrt(2);
if ab(1)>ab(2)
  el.phi=0;
else
  el.phi=pi/2;
end
