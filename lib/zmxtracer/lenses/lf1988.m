function lens = lf1988
% ZEMAX/THORLABS/ZMX/LF1988-A.ZMX - LF1988 - Negative Meniscus - N-BK7

lens.fn = 'lf1988';
lens.name = 'LF1988-A';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.004, 0.0079151495963274 ];
lens.tc = [ 3 ];
lens.conj = [ inf, -492.3988683393];
lens.conjcurv = [ 0, 0];
