function ar = arrowhead_calc(x,y,ang,l,w)
% ARROWHEAD_CALC - For internal use by ARROWHEAD and RECALCSHIFTS only

[xi,yi] = oneinch;

if abs(imag(ang)) > abs(real(ang))
  dx = cos(ang/i) * xi;
  dy = sin(ang/i) * yi;
  dr = sqrt(dx^2+dy^2);
  dx = dx / dr;
  dy = dy / dr;
  Dx = -sin(ang/i) * xi;
  Dy = cos(ang/i) * yi;
  Dr = sqrt(Dx^2+Dy^2);
  Dx = Dx / Dr;
  Dy = Dy / Dr;
else
  dx = cos(ang);
  dy = sin(ang);
  Dx = -sin(ang);
  Dy = cos(ang);
end
% Now, (dx,dy) is a unit vector in data coordinates in the direction 
% of the arrow, and (Dx,Dy) is a unit vector in the orthogonal direction.

% Now, what is one inch along those vectors?
ri = 1/sqrt(dx^2/xi^2 + dy^2/yi^2);
Ri = 1/sqrt(Dx^2/xi^2 + Dy^2/yi^2);

% The tip of the arrow
ar.x0 = x-dx*ri*l(2);
ar.y0 = y-dy*ri*l(2);

% The dimple of the arrow
ar.x1 = x-dx*ri*(l(2)+l(1)-l(3));
ar.y1 = y-dy*ri*(l(2)+l(1)-l(3));

% The feathers
ar.xl = x-dx*ri*(l(2)+l(1)) - Dx*Ri*w;
ar.yl = y-dy*ri*(l(2)+l(1)) - Dy*Ri*w;

ar.xr = x-dx*ri*(l(2)+l(1)) + Dx*Ri*w;
ar.yr = y-dy*ri*(l(2)+l(1)) + Dy*Ri*w;
