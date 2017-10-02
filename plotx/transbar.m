function p=transbar(x,y,edg)
% p = TRANSBAR(x,y) plots transparent bars for the data X,Y. That is, just
% thin horizontal line segments.
% p = TRANSBAR(x,y,1) connects adjacent line segments with vertical segments.
if nargin<3
  edg=0;
end

x=x(:)';
y=y(:)';
dx=median(diff(x));
xl = [x(1)-dx/2   (x(1:end-1)+x(2:end))/2];
xr = [(x(1:end-1)+x(2:end))/2   x(end)+dx/2];

if edg
  xx=[xl; xr];
  yy=[y; y];
else
  xx=[xl; xr; xr];
  yy=[y; y; nan*y];
end

p=plot(xx(:),yy(:));
