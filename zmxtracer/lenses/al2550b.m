function lens = al2550b
% ZMX/AL2550-B.ZMX - Ø25 mm, f=50 mm, NA=0.230, N-BK7 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al2550b';
lens.name = 'AL2550-B';
lens.diam = [ 25, 21.95744568264 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0391236306729265, 0 ];
lens.tc = [ 6 ];
lens.conj = [ inf, 46.03123281323];
lens.conjcurv = [ 0, 0];
