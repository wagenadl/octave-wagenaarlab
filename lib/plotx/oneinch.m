function [x,y]=oneinch(h)
% [x,y] = ONEINCH returns the distance in graph coordinates that correspond
% to one inch in the paper print.
% [x,y] = ONEINCH(h) looks at axes H rather than current axes.
% xy = ONEINCH(...) returns results in a single 1x2 variable.

if nargin<1
  h=gca;
end
f=get(h,'parent');
funit = get(f,'paperunits');
set(f,'paperunits','inches');
hunit = get(h,'units');
set(h,'units','normalized');

pbox=get(f,'paperposition');
abox=get(h,'position');
ax=[get(h,'xlim') get(h,'ylim')];

set(f,'paperunits',funit);
set(h,'units',hunit);

sc = pbox(3:4).*abox(3:4);
x = [ax(2)-ax(1), ax(4)-ax(3)] ./ sc;
if nargout>1
  y = x(2);
  x = x(1);
end

