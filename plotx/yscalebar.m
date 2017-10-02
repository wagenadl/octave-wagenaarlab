function ys = yscalebar(x,yb,h,str)
% YSCALEBAR(x,yb,h,str) places a vertical scale bar at (YB,X),
% with label STR and height H.
% ys = YSCALEBAR(x,yb,h,str) returns a structure of handles, as per
% YTICKBAR.

if nargin<4
  str='';
end

ys = ytickbar([yb yb+h/2 yb+h],x,.05,{'',str,''},'');
delete(ys.li);

if nargout<1
  clear ys
end
