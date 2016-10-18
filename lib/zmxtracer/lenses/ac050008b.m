function lens = ac050008b
% ZMX/AC050-008-B.ZMX - AC050-008-B NEAR IR ACHROMATS: Infinite Conjugate 7.5

lens.fn = 'ac050008b';
lens.name = 'AC050-008-B';
lens.diam = [ 5, 5, 5 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.216919739696312, -0.256410256410256, -0.0278164116828929 ];
lens.tc = [ 2.8, 1.8 ];
lens.conj = [ inf, 4.73073380134];
lens.conjcurv = [ 0, 0];
