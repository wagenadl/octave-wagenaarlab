function lens = ac050008
% ZMX/AC050-008-A.ZMX - AC050-008-A POSITIVE VISIBLE ACHROMATS: Infinite 7.5

lens.fn = 'ac050008';
lens.name = 'AC050-008-A';
lens.diam = [ 5, 5, 5 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.19047619047619, -0.256410256410256, -0.0586166471277843 ];
lens.tc = [ 2.8, 1.7 ];
lens.conj = [ inf, 5.140663445935];
lens.conjcurv = [ 0, 0];
