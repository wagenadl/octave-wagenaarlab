function lens = lc2632
% ZEMAX/THORLABS/ZMX/LC2632-A.ZMX - LC2632 Plano-Concave - N-SF11

lens.fn = 'lc2632';
lens.name = 'LC2632-A';
lens.diam = [ 6, 6 ];
lens.glass = { @nsf11 };
lens.curv = [ -0.107066381156317, 0 ];
lens.tc = [ 2 ];
lens.conj = [ inf, -12.73589986944];
lens.conjcurv = [ 0, 0];
