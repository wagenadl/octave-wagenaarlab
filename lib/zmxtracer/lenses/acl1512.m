function lens = acl1512
% ZEMAX/THORLABS/ZMX/ACL1512-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø15 mm, f=12 mm

lens.fn = 'acl1512';
lens.name = 'ACL1512-A';
lens.diam = [ 13.5, 15, 10.280530897036 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.159312788356147, 0 ];
lens.tc = [ 5, 8 ];
lens.conj = [ inf, 6.687914140236];
lens.conjcurv = [ 0, 0];
