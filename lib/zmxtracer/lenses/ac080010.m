function lens = ac080010
% ZMX/AC080-010-A.ZMX - AC080-010-A POSITIVE VISIBLE ACHROMATS: Infinite 10

lens.fn = 'ac080010';
lens.name = 'AC080-010-A';
lens.diam = [ 8, 8, 8 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.141242937853107, -0.19047619047619, -0.0441306266548985 ];
lens.tc = [ 4.5, 2 ];
lens.conj = [ inf, 6.5559890356];
lens.conjcurv = [ 0, 0];
