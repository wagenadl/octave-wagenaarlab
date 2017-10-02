function h=backbox(xywh,fc,lc)
% h = BACKBOX(xywh,fc,lc) draws a rectangle behind a graph.
% XYWH defines the position of the box.
% FC (optional) defines the face color.
% LC (optional) defines the edge color.
% Returns a (surf) handle.

if nargin<2 | isempty(fc)
  fc = [.8 .8 .8];
end
if nargin<3 | isempty(lc)
  lc = .5 * fc;
end

ho=ishold;
hold on

h=surf(xywh(1)+xywh(3)*[0 0; 1 1],xywh(2)+xywh(4)*[0 1; 0 1],[-1 -1; -1 -1]);
set(h,'facecolor',fc);
set(h,'edgecolor',lc);

if ~ho
  hold off
end
