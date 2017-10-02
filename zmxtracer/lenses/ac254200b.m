function lens = ac254200b
% ZMX/AC254-200-B.ZMX - AC254-200-B NEAR IR ACHROMATS: Infinite Conjugate 200

lens.fn = 'ac254200b';
lens.name = 'AC254-200-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nlak22, @sf10 };
lens.curv = [ 0.0093976130062964, -0.010350895352448, 0.0005 ];
lens.tc = [ 4, 4 ];
lens.conj = [ inf, 194.7748276333];
lens.conjcurv = [ 0, 0];
