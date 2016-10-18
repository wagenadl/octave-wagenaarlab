function lens = ac300100
% ZMX/AC300-100-A.ZMX - AC300-100-A POSITIVE VISIBLE ACHROMATS: Infinite 100

lens.fn = 'ac300100';
lens.name = 'AC300-100-A';
lens.diam = [ 30, 30, 30 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0142857142857143, -0.0175377060680463, -0.0035161744022504 ];
lens.tc = [ 5, 2 ];
lens.conj = [ inf, 96.22911186601];
lens.conjcurv = [ 0, 0];
