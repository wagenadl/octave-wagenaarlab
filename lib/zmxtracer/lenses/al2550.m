function lens = al2550
% ZEMAX/THORLABS/ZMX/AL2550-A.ZMX - Ø25 mm, f=50 mm, NA=0.230, N-BK7 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al2550';
lens.name = 'AL2550-A';
lens.diam = [ 25, 21.95744568264 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0391236306729265, 0 ];
lens.tc = [ 6 ];
lens.conj = [ inf, 46.03123281323];
lens.conjcurv = [ 0, 0];
