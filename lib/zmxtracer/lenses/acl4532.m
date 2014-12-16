function lens = acl4532
% ZEMAX/THORLABS/ZMX/ACL4532-A.ZMX - Aspheric Condenser Lens, AR-Coated 350-700 nm, Ø45 mm, f=32 mm

lens.fn = 'acl4532';
lens.name = 'ACL4532-A';
lens.diam = [ 40.5, 45, 36.45974970934 ];
lens.glass = { @(x) (1), @b270 };
lens.curv = [ 0, 0.0547025782528587, -0.00769230769230769 ];
lens.tc = [ 5, 18.5 ];
lens.conj = [ inf, 22.75321435138];
lens.conjcurv = [ 0, 0];
