function lens = ac508080b
% ZMX/AC508-080-B.ZMX - AC508-080-B NEAR IR ACHROMATS: Infinite Conjugate 80

lens.fn = 'ac508080b';
lens.name = 'AC508-080-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0193050193050193, -0.0224215246636771, -0.0031989763275752 ];
lens.tc = [ 16, 2 ];
lens.conj = [ inf, 69.06965875745];
lens.conjcurv = [ 0, 0];
