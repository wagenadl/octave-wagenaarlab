function lens = ac254030b
% ZMX/AC254-030-B.ZMX - AC254-030-B NEAR IR ACHROMATS: Infinite Conjugate 30

lens.fn = 'ac254030b';
lens.name = 'AC254-030-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0474158368895211, -0.0618046971569839, -0.0126454223571067 ];
lens.tc = [ 12, 1.5 ];
lens.conj = [ inf, 22.49736888094];
lens.conjcurv = [ 0, 0];
