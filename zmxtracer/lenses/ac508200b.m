function lens = ac508200b
% ZMX/AC508-200-B.ZMX - AC508-200-B NEAR IR ACHROMATS: Infinite Conjugate 200

lens.fn = 'ac508200b';
lens.name = 'AC508-200-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0074626865671642, -0.0091575091575092, -0.0019409937888199 ];
lens.tc = [ 8.2, 5 ];
lens.conj = [ inf, 193.1426217225];
lens.conjcurv = [ 0, 0];
