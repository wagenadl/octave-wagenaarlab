function xs = xscalebar(xl,y,w,str)
% XSCALEBAR(xl,y,w,str) places a horizontal scale bar at (XL,Y),
% with label STR and width W.
% xs = XSCALEBAR(xl,y,w,str) returns a structure of handles, as per
% XTICKBAR.

if nargin<4
  str='';
end

xs = xtickbar([xl xl+w/2 xl+w],y,-.05,{'',str,''},'');
delete(xs.li);

if nargout<1
  clear xs
end
