function lens = acl2520
% ZEMAX/THORLABS/ZMX/ACL2520-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø25 mm, f=20 mm

lens.fn = 'acl2520';
lens.name = 'ACL2520-A';
lens.diam = [ 22.5, 25, 18.299779478936 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.0955876730136881, 0 ];
lens.tc = [ 5, 12 ];
lens.conj = [ inf, 12.03151817261];
lens.conjcurv = [ 0, 0];
