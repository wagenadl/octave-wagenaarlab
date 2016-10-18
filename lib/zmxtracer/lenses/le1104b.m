function lens = le1104b
% ZMX/LE1104-B.ZMX - LE1104 - Positive Meniscus - N-BK7

lens.fn = 'le1104b';
lens.name = 'LE1104-B';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0203832042397065, 0.0076010945576163 ];
lens.tc = [ 3.05 ];
lens.conj = [ inf, 144.1677554119];
lens.conjcurv = [ 0, 0];
