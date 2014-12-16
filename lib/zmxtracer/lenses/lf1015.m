function lens = lf1015
% ZEMAX/THORLABS/ZMX/LF1015-A.ZMX - LF1015 - Negative Meniscus - N-BK7

lens.fn = 'lf1015';
lens.name = 'LF1015-A';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.004, 0.0105141415203449 ];
lens.tc = [ 3 ];
lens.conj = [ inf, -294.0971121048];
lens.conjcurv = [ 0, 0];
