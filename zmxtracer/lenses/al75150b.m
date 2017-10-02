function lens = al75150b
% ZMX/AL75150-B.ZMX - LA75150-B Ø75 mm, f=150 mm, NA=0.230, N-BK7 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al75150b';
lens.name = 'AL75150-B';
lens.diam = [ 75, 66.80471428272 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0130412102243088, 0 ];
lens.tc = [ 15 ];
lens.conj = [ inf, 140.0788998628];
lens.conjcurv = [ 0, 0];
