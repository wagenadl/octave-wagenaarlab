function lens = acl108b
% ZMX/ACL108-B.ZMX - Aspheric Condenser Lens, AR-Coated 650-1050 nm, Ø10 mm, f=8 mm

lens.fn = 'acl108b';
lens.name = 'ACL108-B';
lens.diam = [ 9, 10, 6.439704813448 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.23896918253422, 0 ];
lens.tc = [ 5, 5.8 ];
lens.conj = [ inf, 4.152420073872];
lens.conjcurv = [ 0, 0];
