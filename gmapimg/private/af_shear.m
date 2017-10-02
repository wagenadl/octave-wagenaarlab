function xf = af_shear(xf, dx, dy)
xf = [1 dx 0; dy 1 0; 0 0 1] * xf;
