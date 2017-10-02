function lens = ac300100b
% ZMX/AC300-100-B.ZMX - AC300-100-B NEAR IR ACHROMATS: Infinite Conjugate 100

lens.fn = 'ac300100b';
lens.name = 'AC300-100-B';
lens.diam = [ 30, 30, 30 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0203707476064372, -0.0180701120346946, 0.0017940437746681 ];
lens.tc = [ 6, 2 ];
lens.conj = [ inf, 94.01486848799];
lens.conjcurv = [ 0, 0];
