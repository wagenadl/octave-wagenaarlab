function lens = ac127050b
% ZMX/AC127-050-B.ZMX - AC127-050-B NEAR IR ACHROMATS: Infinite Conjugate 50

lens.fn = 'ac127050b';
lens.name = 'AC127-050-B';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0413223140495868, -0.0373273609555804, 0.004 ];
lens.tc = [ 3.5, 1.5 ];
lens.conj = [ inf, 46.1712950008];
lens.conjcurv = [ 0, 0];
