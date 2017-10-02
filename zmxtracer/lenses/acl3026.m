function lens = acl3026
% ZMX/ACL3026-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø30 mm, f=26.5 mm

lens.fn = 'acl3026';
lens.name = 'ACL3026-A';
lens.diam = [ 27, 30, 24.28781038614 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.0721526750604279, 0 ];
lens.tc = [ 5, 11 ];
lens.conj = [ inf, 22.62740077285];
lens.conjcurv = [ 0, 0];
