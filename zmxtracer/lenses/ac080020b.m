function lens = ac080020b
% ZMX/AC080-020-B.ZMX - AC080-020-B NEAR IR ACHROMATS: Infinite Conjugate 20

lens.fn = 'ac080020b';
lens.name = 'AC080-020-B';
lens.diam = [ 8, 8, 8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.073909830007391, -0.0944287063267233, -0.0209424083769634 ];
lens.tc = [ 2.3, 1.3 ];
lens.conj = [ inf, 18.16943613386];
lens.conjcurv = [ 0, 0];
