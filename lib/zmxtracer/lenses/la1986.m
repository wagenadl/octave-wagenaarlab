function lens = la1986
% ZEMAX/THORLABS/ZMX/LA1986-A.ZMX - LA1986 Plano-Convex - N-BK7

lens.fn = 'la1986';
lens.name = 'LA1986-A';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0155327741534638, 0 ];
lens.tc = [ 3.26 ];
lens.conj = [ inf, 121.4037132363];
lens.conjcurv = [ 0, 0];
