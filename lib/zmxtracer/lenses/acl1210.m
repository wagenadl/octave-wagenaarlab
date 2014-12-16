function lens = acl1210
% ZEMAX/THORLABS/ZMX/ACL1210-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø12 mm, f=10.5 mm

lens.fn = 'acl1210';
lens.name = 'ACL1210-A';
lens.diam = [ 10.8, 12, 8.674202975618 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.182071758121311, 0 ];
lens.tc = [ 5, 5.8 ];
lens.conj = [ inf, 6.650110431829];
lens.conjcurv = [ 0, 0];
