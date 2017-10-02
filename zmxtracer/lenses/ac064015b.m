function lens = ac064015b
% ZMX/AC064-015-B.ZMX - AC064-015-B NEAR IR ACHROMATS: Infinite Conjugate 15

lens.fn = 'ac064015b';
lens.name = 'AC064-015-B';
lens.diam = [ 6.35, 6.35, 6.35 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0972762645914397, -0.129032258064516, -0.0304043782304652 ];
lens.tc = [ 2.4, 1.5 ];
lens.conj = [ inf, 13.03397884072];
lens.conjcurv = [ 0, 0];
