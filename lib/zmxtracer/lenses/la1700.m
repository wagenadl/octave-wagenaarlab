function lens = la1700
% ZEMAX/THORLABS/ZMX/LA1700-A.ZMX - LA1700 Plano-Convex - N-BK7

lens.fn = 'la1700';
lens.name = 'LA1700-A';
lens.diam = [ 6, 6 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0647249190938511, 0 ];
lens.tc = [ 1.79 ];
lens.conj = [ inf, 28.47759740423];
lens.conjcurv = [ 0, 0];
