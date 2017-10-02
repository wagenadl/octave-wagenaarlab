function lens = ac508150b
% ZMX/AC508-150-B.ZMX - AC508-150-B NEAR IR ACHROMATS: Infinite Conjugate 150

lens.fn = 'ac508150b';
lens.name = 'AC508-150-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0089118616879066, -0.0104231811548885, -0.0030759766225777 ];
lens.tc = [ 8.2, 5 ];
lens.conj = [ inf, 144.3196208188];
lens.conjcurv = [ 0, 0];
