function lens = acl2018
% ZEMAX/THORLABS/ZMX/ACL2018-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø20 mm, f=18 mm

lens.fn = 'acl2018';
lens.name = 'ACL2018-A';
lens.diam = [ 18, 20, 15.682106968882 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.106208525570765, 0 ];
lens.tc = [ 5, 8 ];
lens.conj = [ inf, 12.68966047547];
lens.conjcurv = [ 0, 0];
