function lens = ac254400b
% ZMX/AC254-400-B.ZMX - AC254-400-B NEAR IR ACHROMATS: Infinite Conjugate 400

lens.fn = 'ac254400b';
lens.name = 'AC254-400-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @sf5, @nsf6ht };
lens.curv = [ 0.0119617224880383, -0.0093976130062964, 0.0055081244836133 ];
lens.tc = [ 3.5, 1.8 ];
lens.conj = [ inf, 391.0775396472];
lens.conjcurv = [ 0, 0];
