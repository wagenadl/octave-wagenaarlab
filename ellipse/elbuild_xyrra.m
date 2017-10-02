function el = elbuild_xyrra(x,y,R,r,phi)
% ELBUILD_XYRRA  Build a struct for ELPLOT_XYRRA
%    el = ELBUILD_XYRRA(x,y,R,r,a) or el = ELBUILD_XYRRA([x,y,R,r,a])
%    builds a xyrra structure.
%    el = ELBUILD_XYRRA(el) where EL is already a xyrra structure just
%    returns el.

if isstruct(x)
  el = x;
elseif nargin==5
  el.x0=x;
  el.y0=y;
  el.R=R;
  el.r=r;
  el.phi=phi;
elseif nargin==1
  el.x0=x(1);
  el.y0=x(2);
  el.R=x(3);
  el.r=x(4);
  el.phi=x(5);
else
  error('ELBUILD_XYRRA needs one or five arguments');
end
