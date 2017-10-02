function lens = ac254035b
% ZMX/AC254-035-B.ZMX - AC254-035-B NEAR IR ACHROMATS: Infinite Conjugate 35

lens.fn = 'ac254035b';
lens.name = 'AC254-035-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0416840350145894, -0.0537056928034372, -0.0102806620746376 ];
lens.tc = [ 10.5, 1.5 ];
lens.conj = [ inf, 28.06009949194];
lens.conjcurv = [ 0, 0];
