function lens = la1252
% ZEMAX/THORLABS/ZMX/LA1252-A.ZMX - LA1252 Plano-Convex - N-BK7

lens.fn = 'la1252';
lens.name = 'LA1252-A';
lens.diam = [ 25, 25 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0763358778625954, 0 ];
lens.tc = [ 11.7 ];
lens.conj = [ inf, 13.06366891176];
lens.conjcurv = [ 0, 0];
