function lens = ac508400b
% ZMX/AC508-400-B.ZMX - AC508-400-B NEAR IR ACHROMATS: Infinite Conjugate 400

lens.fn = 'ac508400b';
lens.name = 'AC508-400-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0035644270183568, -0.0048076923076923, -0.0011641443538999 ];
lens.tc = [ 4.5, 2.6 ];
lens.conj = [ inf, 393.6222566819];
lens.conjcurv = [ 0, 0];
