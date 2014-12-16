function lens = lc1975
% ZEMAX/THORLABS/ZMX/LC1975-A.ZMX - LC1975 Plano-Concave - N-BK7

lens.fn = 'lc1975';
lens.name = 'LC1975-A';
lens.diam = [ 6, 6 ];
lens.glass = { @nbk7 };
lens.curv = [ -0.0809716599190283, 0 ];
lens.tc = [ 2 ];
lens.conj = [ inf, -24.96374022026];
lens.conjcurv = [ 0, 0];
