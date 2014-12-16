function lens = acl12708u
% ZEMAX/THORLABS/ZMX/ACL12708U-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø12.7 mm, f=8 mm

lens.fn = 'acl12708u';
lens.name = 'ACL12708U-A';
lens.diam = [ 11.43, 12.7, 12.7 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.21038795711625, -0.0639002015088167 ];
lens.tc = [ 5, 7.5 ];
lens.conj = [ inf, 3.722068442237];
lens.conjcurv = [ 0, 0];
