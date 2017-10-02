function lens = acl1815b
% ZMX/ACL1815-B.ZMX - Aspheric Condenser Lens, AR-Coated 650-1050 nm, Ø18 mm, f=15 mm

lens.fn = 'acl1815b';
lens.name = 'ACL1815-B';
lens.diam = [ 16.2, 18, 18 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.126502533396428, 0 ];
lens.tc = [ 5, 6.8 ];
lens.conj = [ inf, 14.11795062781];
lens.conjcurv = [ 0, 0];
