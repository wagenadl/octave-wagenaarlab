function lens = acl5040
% ZMX/ACL5040-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø50 mm, f=40 mm

lens.fn = 'acl5040';
lens.name = 'ACL5040-A';
lens.diam = [ 45, 50, 39.18679420942 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.0477938342225934, 0 ];
lens.tc = [ 5, 21 ];
lens.conj = [ inf, 26.00245765596];
lens.conjcurv = [ 0, 0];
