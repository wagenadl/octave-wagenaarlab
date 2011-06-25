function shifth(hh,dx,dy)
% SHIFTH - Shift a handle graphics item around
%   SHIFTH(hh,dx,dy) moves the items with handles HH by a distance (DX,DY).
%   If DX or DY is imaginary, values are measured in inches, otherwise,
%   in axis units.

if nargin<3
  dy=dx(2);
  dx=dx(1);
end

[d_x,d_y]=oneinch;
if abs(imag(dx))>abs(real(dx))
  dx = dx*d_x/i;
end
if abs(imag(dy))>abs(real(dy))
  dy = dy*d_y/i;
end

for h=hh(:)'
  xy=get(h,'position');
  xy(1)=xy(1)+dx;
  xy(2)=xy(2)+dy;
  set(h,'position',xy);
end
