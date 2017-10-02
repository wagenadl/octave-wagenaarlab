function lens = ac080016b
% ZMX/AC080-016-B.ZMX - AC080-016-B NEAR IR ACHROMATS: Infinite Conjugate 16

lens.fn = 'ac080016b';
lens.name = 'AC080-016-B';
lens.diam = [ 8, 8, 8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0907441016333938, -0.116279069767442, -0.0279251605696733 ];
lens.tc = [ 2.5, 1.5 ];
lens.conj = [ inf, 13.95674733142];
lens.conjcurv = [ 0, 0];
