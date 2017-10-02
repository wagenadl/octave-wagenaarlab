function lens = ac254150b
% ZMX/AC254-150-B.ZMX - AC254-150-B NEAR IR ACHROMATS: Infinite Conjugate 150

lens.fn = 'ac254150b';
lens.name = 'AC254-150-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0119617224880383, -0.0111944475540132, -0.0007515971439309 ];
lens.tc = [ 4, 3.5 ];
lens.conj = [ inf, 144.6015039335];
lens.conjcurv = [ 0, 0];
