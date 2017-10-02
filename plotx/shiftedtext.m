function h = shiftedtext(x,y,dx,dy,txt,varargin)
% SHIFTEDTEXT - Add a text label to a graph using composite positioning
%    SHIFTEDTEXT(x,y,dx,dy,txt) places the label TXT on the current axes,
%    positioned a distance (DX,DY) inches away from data coordinates (X,Y).
%    SHIFTEDTEXT(x,y,dx,dy,txt, pname1, pval1, ...) specifies additional
%    properties.
%    h = SHIFTEDTEXT(...) returns an object handle.
%    After any change of AXIS or PAPERPOSITION, it is critical to call
%    RECALCSHIFTS to properly position the texts.

[xi,yi] = oneinch;
h = text(x+dx*xi, y+dy*yi, txt, varargin{:});
setappdata(h,'shiftedtext_data',[x y dx dy]);

if nargout<1
  clear h;
end
