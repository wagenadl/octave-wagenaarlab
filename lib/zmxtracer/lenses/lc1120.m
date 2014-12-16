function lens = lc1120
% ZEMAX/THORLABS/ZMX/LC1120-A.ZMX - LC1120 Plano-Concave - N-BK7

lens.fn = 'lc1120';
lens.name = 'LC1120-A';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @nbk7 };
lens.curv = [ -0.0194325689856199, 0 ];
lens.tc = [ 4 ];
lens.conj = [ inf, -101.0940419263];
lens.conjcurv = [ 0, 0];
