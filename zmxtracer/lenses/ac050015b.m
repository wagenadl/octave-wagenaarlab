function lens = ac050015b
% ZMX/AC050-015-B.ZMX - AC050-015-B NEAR IR ACHROMATS: Infinite Conjugate 15

lens.fn = 'ac050015b';
lens.name = 'AC050-015-B';
lens.diam = [ 5, 5, 5 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0972762645914397, -0.131752305665349, -0.0311138767890479 ];
lens.tc = [ 2.3, 1.7 ];
lens.conj = [ inf, 13.02282865621];
lens.conjcurv = [ 0, 0];
