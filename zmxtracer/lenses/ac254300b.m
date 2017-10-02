function lens = ac254300b
% ZMX/AC254-300-B.ZMX - AC254-300-B NEAR IR ACHROMATS: Infinite Conjugate 300

lens.fn = 'ac254300b';
lens.name = 'AC254-300-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @sf5, @nsf6ht };
lens.curv = [ 0.016025641025641, -0.0129198966408269, 0.0074626865671642 ];
lens.tc = [ 4, 2 ];
lens.conj = [ inf, 290.0467033941];
lens.conjcurv = [ 0, 0];
