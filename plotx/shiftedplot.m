function h = shiftedplot(x,y,dx,dy,varargin)
% SHIFTEDPLOT - Linear plot using composite positioning
%    SHIFTEDPLOT(x,y,dx,dy) is like PLOT(x,y), except that the plot is
%    shifted by a distance (DX,DY) specified in inches.
%    DX, DY may be scalars or vectors. If they are vectors, they must be
%    the same size as X, Y.
%    SHIFTEDPLOT(x,y,dx,dy, s), where S is a string, is like PLOT(x,y,s).
%    SHIFTEDPLOT(x,y,dx,dy, pname1, pval1, ...) specifies additional
%    properties.
%    h = SHIFTEDPLOT(...) returns an object handle.
%    After any change of AXIS or PAPERPOSITION, it is critical to call
%    RECALCSHIFTS to properly position the plot.

[xi,yi] = oneinch;
h = plot(x+dx*xi, y+dy*yi, varargin{:});
setappdata(h,'shiftedplot_data',{x, y, dx, dy});

if nargout<1
  clear h;
end
