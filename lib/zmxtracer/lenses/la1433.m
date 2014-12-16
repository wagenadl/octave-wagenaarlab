function lens = la1433
% ZEMAX/THORLABS/ZMX/LA1433-A.ZMX - LA1433 Plano-Convex - N-BK7

lens.fn = 'la1433';
lens.name = 'LA1433-A';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0129433083096039, 0 ];
lens.tc = [ 3.05 ];
lens.conj = [ inf, 146.5433412225];
lens.conjcurv = [ 0, 0];
