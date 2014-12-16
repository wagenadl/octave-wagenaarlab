function lens = acl1815
% ZEMAX/THORLABS/ZMX/ACL1815-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø18 mm, f=15 mm

lens.fn = 'acl1815';
lens.name = 'ACL1815-A';
lens.diam = [ 16.2, 18, 18 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.126502533396428, 0 ];
lens.tc = [ 5, 6.8 ];
lens.conj = [ inf, 14.11795062781];
lens.conjcurv = [ 0, 0];
