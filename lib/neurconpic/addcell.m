function c=addcell(x,y,r,lbl,circpar,txtpar)
% ADDCELL - Add a neuron to a NEURCONPIC graph
%    c = ADDCELL(x,y,r,lbl) adds a circular representation of a neuron
%    to the current graph.
%    c = ADDCELL(...,circpar,txtpar) specifies additional parameters
%    for the circle (which is a matlab RECTANGLE) and the label.

c.x = x;
c.y = y;
c.r = r;
c.lbl = lbl;

c.recth = rectangle('position',[x-r y-r 2*r 2*r],'curvature',[1 1],...
    'edgecolor','k','facecolor',[.9 .9 .9]);
if nargin>=5
  set(c.recth,circpar{:});
end
c.texth = text(x,y,lbl,'horizontala','center','verticala','middle');
if nargin>=6
  set(c.texth,txtpar{:});
end
  
