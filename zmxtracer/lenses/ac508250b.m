function lens = ac508250b
% ZMX/AC508-250-B.ZMX - AC508-250-B NEAR IR ACHROMATS: Infinite Conjugate 250

lens.fn = 'ac508250b';
lens.name = 'AC508-250-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.008249463784854, -0.0068427535240181, 0.0008091269520188 ];
lens.tc = [ 6.6, 2.6 ];
lens.conj = [ inf, 243.1468609294];
lens.conjcurv = [ 0, 0];
