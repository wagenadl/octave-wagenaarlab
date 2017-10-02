function lens = acl1512b
% ZMX/ACL1512-B.ZMX - Aspheric Condenser Lens, AR-Coated 650-1050 nm, Ø15 mm, f=12 mm

lens.fn = 'acl1512b';
lens.name = 'ACL1512-B';
lens.diam = [ 13.5, 15, 10.280530897036 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.159312788356147, 0 ];
lens.tc = [ 5, 8 ];
lens.conj = [ inf, 6.687914140236];
lens.conjcurv = [ 0, 0];
