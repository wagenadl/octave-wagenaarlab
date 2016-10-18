function lens = ac508300b
% ZMX/AC508-300-B.ZMX - AC508-300-B NEAR IR ACHROMATS: Infinite Conjugate 300

lens.fn = 'ac508300b';
lens.name = 'AC508-300-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0049554013875124, -0.0061919504643963, -0.0013157894736842 ];
lens.tc = [ 6.6, 2.6 ];
lens.conj = [ inf, 295.1247765571];
lens.conjcurv = [ 0, 0];
