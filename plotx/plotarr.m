function h = plotarr(x,y,dx,dy)
% PLOTARR - Plot a series of arrow heads
%    PLOTARR(x,y) plots arrow heads along the curve (x,y).
%    PLOTARR(x,y,dx,dy) specifies directions for the arrow heads (otherwise,
%    they point along the curve).
%    PLOTARR(x,y,n) plots only every N-th point, but does use the intermediate
%    points for direction.
%    PLOTARR(x,y,dx,dy,l,w) specifies length and width of the arrow heads.
%    (Default is 0.075 x 0.025 inch.)
%    h = PLOTARR(...) returns plot handles

if nargin<3
  dx=[];
end
if nargin<4
  dy=[];
end
if nargin<6
  l=.075;
  w=.025;
end

x=x(:);
y=y(:);

if isempty(dy) & ~isempty(dx)
  dn = dx;
  dx = [];
else
  dn = 1;
end

if isempty(dy)
  if length(x)<2
    error('PLOTARR needs direction information unless there are at least two points');
  elseif length(x)==2
    dx=[1;1]*diff(x);
    dy=[1;1]*diff(y);
  else
    dx=[x(2)-x(1); (x(3:end)-x(1:end-2))/2; x(end)-x(end-1)];
    dy=[y(2)-y(1); (y(3:end)-y(1:end-2))/2; y(end)-y(end-1)];
  end
end

ish=ishold;
hold on

h=zeros(length(x),1)+nan;
for k=1:dn:length(x)
  h(k) = arrowhead(x(k),y(k),atan2(dy(k),dx(k)),[l -l/3 0],w,'solid');
end

if ~ish
  hold off
end

if nargout<1
  clear h
else
  h = h(~isnan(h));
end
