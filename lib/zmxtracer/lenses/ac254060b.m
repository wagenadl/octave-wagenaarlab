function lens = ac254060b
% ZMX/AC254-060-B.ZMX - AC254-060-B NEAR IR ACHROMATS: Infinite Conjugate 60

lens.fn = 'ac254060b';
lens.name = 'AC254-060-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0253292806484296, -0.0303030303030303, -0.0060532687651332 ];
lens.tc = [ 6, 1.7 ];
lens.conj = [ inf, 55.69909364985];
lens.conjcurv = [ 0, 0];
