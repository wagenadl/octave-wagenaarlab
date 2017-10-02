function xf = af_rotate(xf, phi)
xf = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1] * xf;
