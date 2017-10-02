function lens = ac060010b
% ZMX/AC060-010-B.ZMX - AC060-010-B NEAR IR ACHROMATS: Infinite Conjugate 10

lens.fn = 'ac060010b';
lens.name = 'AC060-010-B';
lens.diam = [ 6, 6, 6 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.141242937853107, -0.19047619047619, -0.0511770726714432 ];
lens.tc = [ 2.5, 1.5 ];
lens.conj = [ inf, 8.007899759496];
lens.conjcurv = [ 0, 0];
