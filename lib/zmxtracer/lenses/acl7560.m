function lens = acl7560
% ZEMAX/THORLABS/ZMX/ACL7560-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø75 mm, f=60 mm

lens.fn = 'acl7560';
lens.name = 'ACL7560-A';
lens.diam = [ 67.5, 75, 60.04774841198 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.0318625566560068, 0 ];
lens.tc = [ 5, 30 ];
lens.conj = [ inf, 39.55962019669];
lens.conjcurv = [ 0, 0];
