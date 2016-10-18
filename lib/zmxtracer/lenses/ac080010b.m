function lens = ac080010b
% ZMX/AC080-010-B.ZMX - AC080-010-B NEAR IR ACHROMATS: Infinite Conjugate 10

lens.fn = 'ac080010b';
lens.name = 'AC080-010-B';
lens.diam = [ 8, 8, 8 ];
lens.glass = { @nlak10, @nsf6ht };
lens.curv = [ 0.132450331125828, -0.216919739696312, -0.0326583932070542 ];
lens.tc = [ 4.5, 1.3 ];
lens.conj = [ inf, 6.845379680061];
lens.conjcurv = [ 0, 0];
