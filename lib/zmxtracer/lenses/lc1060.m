function lens = lc1060
% ZEMAX/THORLABS/ZMX/LC1060-A.ZMX - LC1060 Plano-Concave - N-BK7

lens.fn = 'lc1060';
lens.name = 'LC1060-A';
lens.diam = [ 12.7, 12.7 ];
lens.glass = { @nbk7 };
lens.curv = [ -0.0648088139987038, 0 ];
lens.tc = [ 3 ];
lens.conj = [ inf, -31.06384671331];
lens.conjcurv = [ 0, 0];
