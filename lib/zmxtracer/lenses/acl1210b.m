function lens = acl1210b
% ZMX/ACL1210-B.ZMX - Aspheric Condenser Lens, AR-Coated 650-1050 nm, Ø12 mm, f=10.5 mm

lens.fn = 'acl1210b';
lens.name = 'ACL1210-B';
lens.diam = [ 10.8, 12, 8.674202975618 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.182071758121311, 0 ];
lens.tc = [ 5, 5.8 ];
lens.conj = [ inf, 6.650110431829];
lens.conjcurv = [ 0, 0];
