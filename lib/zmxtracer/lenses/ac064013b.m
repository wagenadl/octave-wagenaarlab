function lens = ac064013b
% ZMX/AC064-013-B.ZMX - AC064-013-B NEAR IR ACHROMATS: Infinite Conjugate 12.7

lens.fn = 'ac064013b';
lens.name = 'AC064-013-B';
lens.diam = [ 6.35, 6.35, 6.35 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.116279069767442, -0.149925037481259, -0.0345184673800483 ];
lens.tc = [ 2.5, 1.4 ];
lens.conj = [ inf, 10.66870187535];
lens.conjcurv = [ 0, 0];
