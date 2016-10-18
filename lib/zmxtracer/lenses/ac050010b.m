function lens = ac050010b
% ZMX/AC050-010-B.ZMX - AC050-010-B NEAR IR ACHROMATS: Infinite Conjugate 10

lens.fn = 'ac050010b';
lens.name = 'AC050-010-B';
lens.diam = [ 5, 5, 5 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.152671755725191, -0.19047619047619, -0.0401767778224186 ];
lens.tc = [ 2.2, 1.6 ];
lens.conj = [ inf, 7.997803606516];
lens.conjcurv = [ 0, 0];
