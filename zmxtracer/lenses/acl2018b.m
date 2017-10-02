function lens = acl2018b
% ZMX/ACL2018-B.ZMX - Aspheric Condenser Lens, AR-Coated 650-1050 nm, Ø20 mm, f=18 mm

lens.fn = 'acl2018b';
lens.name = 'ACL2018-B';
lens.diam = [ 18, 20, 15.682106968882 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.106208525570765, 0 ];
lens.tc = [ 5, 8 ];
lens.conj = [ inf, 12.68966047547];
lens.conjcurv = [ 0, 0];
