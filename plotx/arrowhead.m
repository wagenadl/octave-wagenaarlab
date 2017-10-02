function h=arrowhead(x,y,ang,l,w,sty,varargin)
% ARROWHEAD - Draw an arrowhead onto a graph
%    ARROWHEAD(x,y,ang,l,w,sty) draws an arrow head pointing to (X,Y)
%    in the direction ANG onto the current graph. The arrow has
%    length L and half-width W.
%    ARROWHEAD(x,y,dx,dy,w,l,sty, pname1,pval1, ...) specifies additional
%    parameters.
%    h = ARROWHEAD(...) returns an object handle (either line or patch).
%
%    (X,Y) are always specified in data coordinates.
%    ANG may be given in data coordinates, or in external coordinates
%    by multiplying by i. (So ANG = i*pi/6 means towards 2'o clock on paper.)
%    W and L are always specified in inches. L may be a single number, a
%    pair [L, DIST], or a triplet [L, DIST, DIMPLE]. DIST specifies the
%    distance (in inches) to pull away from the target. DIMPLE specifies
%    how much the back end of the head is indented.
%    STY must be one of 'lines', 'open', 'solid'.

if nargin<4
  w=.05;
end
if nargin<5
  l=.10;
end
if nargin<6
  sty='lines';
end

switch length(l)
  case 1
    l=[l 0 0];
  case 2
    l=[l(:)' 0];
  case 3
    l=l(:)';
  otherwise
    error('arrowhead: L must be one, two, or three numbers');
end

ar = arrowhead_calc(x,y,ang,l,w);

switch sty
  case {'','l','lines'}
    h = plot([ar.xr ar.x0 ar.xl],[ar.yr ar.y0 ar.yl],'k',...
	varargin{:});
  case {'o','open'}
    h = patch([ar.xr ar.x0 ar.xl ar.x1],[ar.yr ar.y0 ar.yl ar.y1],'k',...
	'facecolor','none','edgecolor','k',varargin{:});
  case {'s','solid'}
    h = patch([ar.xr ar.x0 ar.xl ar.x1],[ar.yr ar.y0 ar.yl ar.y1],'k',...
	'facecolor','k','edgecolor','none',varargin{:});
end

setappdata(h,'arrowhead_data',[x y ang l w]);
