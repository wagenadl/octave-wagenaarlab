function xf = af_scale(xf, sx, sy)
if nargin<3
  sy = sx;
end

xf = [sx 0 0; 0 sy 0; 0 0 1] *xf;
  