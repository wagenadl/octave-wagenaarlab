function h = errorfill(x,y,dy,varargin)
% ERRORFILL - Plot error bars as a solid patch
%    ERRORFILL(x,y,dy) creates a patch that outlines the error bars DY
%    around the curve (X,Y).
%    ERRORFILL(x,y,dy, pname1,pval1,...) specifies additional parameters.
%    h = ERRORFILL(...) returns a PATCH handle.

idx=~isnan(x) & ~isnan(y) & ~isnan(dy);
x=x(idx); y=y(idx); dy=dy(idx);
x=x(:); y=y(:); dy=dy(:);
[xx,oo]=sort(x);
yy=y(oo);
dy=dy(oo);

h = patch([xx; flipud(xx)],[yy-dy; flipud(yy+dy)],'k');
set(h,'edgecolor','none','facecolor',[.7 .7 .7]);
if nargin>3
  set(h,varargin{:});
end

if nargout<1
  clear h;
end
