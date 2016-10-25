function xf = af_perspective(xf, dx, dy)

xf = [1 0 0; 0 1 0; dx dy 1] * xf;
