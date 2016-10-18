function lens = ac508075b
% ZMX/AC508-075-B.ZMX - AC508-075-B NEAR IR ACHROMATS: Infinite Conjugate 75

lens.fn = 'ac508075b';
lens.name = 'AC508-075-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0193050193050193, -0.0107399849640211, -0.0034355996839248 ];
lens.tc = [ 12, 5 ];
lens.conj = [ inf, 62.29496592848];
lens.conjcurv = [ 0, 0];
