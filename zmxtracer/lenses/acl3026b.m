function lens = acl3026b
% ZMX/ACL3026-B.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø45 mm, f=32 mm

lens.fn = 'acl3026b';
lens.name = 'ACL3026-B';
lens.diam = [ 27, 30, 24.28781038614 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.0721526750604279, 0 ];
lens.tc = [ 5, 11 ];
lens.conj = [ inf, 22.62740077285];
lens.conjcurv = [ 0, 0];
