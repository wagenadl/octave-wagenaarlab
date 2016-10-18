function lens = acn127020b
% ZMX/ACN127-020-B.ZMX - ACN127-020-B NEAR IR NEGATIVE ACHROMATS: Infinite -20

lens.fn = 'acn127020b';
lens.name = 'ACN127-020-B';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ -0.0810372771474878, 0.0712758374910905, 0.0065462162869861 ];
lens.tc = [ 1.5, 3 ];
lens.conj = [ inf, -22.33856639218];
lens.conjcurv = [ 0, 0];
