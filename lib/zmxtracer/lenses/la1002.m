function lens = la1002
% ZEMAX/THORLABS/ZMX/LA1002-A.ZMX - LA1002 Plano-Convex - N-BK7

lens.fn = 'la1002';
lens.name = 'LA1002-A';
lens.diam = [ 75, 75 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0129433083096039, 0 ];
lens.tc = [ 12.71 ];
lens.conj = [ inf, 134.9914236721];
lens.conjcurv = [ 0, 0];
