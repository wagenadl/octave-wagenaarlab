function p=arrowplot(x,y,l,w);
% p = ARROWPLOT(x,y,l,w) connects the set of points (X,Y) with arrows
% of length L and width W (relative to the size of the plot).

dx = max(x) - min(x);
dy = max(y) - min(y);

N=length(x);
if length(y) ~= N
  error('arrowplot must have equal length X and Y vectors');
end

p=zeros(0,1);

for k=2:N
  dd = sqrt(((x(k)-x(k-1))/dx)^2 + ((y(k)-y(k-1))/dy)^2);
  ww = w/dd;
  ll = l/dd;
  p=[p arrow(x(k-1:k),y(k-1:k),ww,ll)];
end
