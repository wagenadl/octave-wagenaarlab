function lens = ac254075b
% ZMX/AC254-075-B.ZMX - AC254-075-B NEAR IR ACHROMATS: Infinite Conjugate 75

lens.fn = 'ac254075b';
lens.name = 'AC254-075-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.02710027100271, -0.0237135404315864, 0.0023934897079943 ];
lens.tc = [ 5, 1.6 ];
lens.conj = [ inf, 69.84467555504];
lens.conjcurv = [ 0, 0];
