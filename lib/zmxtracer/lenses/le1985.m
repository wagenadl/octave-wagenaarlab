function lens = le1985
% ZEMAX/THORLABS/ZMX/LE1985-A.ZMX - LE1985 - Positive Meniscus - N-BK7

lens.fn = 'le1985';
lens.name = 'LE1985-A';
lens.diam = [ 50.8, 50.8 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0099920063948841, 0.0035826884494124 ];
lens.tc = [ 5.1 ];
lens.conj = [ inf, 289.6951417119];
lens.conjcurv = [ 0, 0];
