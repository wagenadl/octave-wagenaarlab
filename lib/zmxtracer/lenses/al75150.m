function lens = al75150
% ZEMAX/THORLABS/ZMX/AL75150-A.ZMX - LA75150-A Ø75 mm, f=150 mm, NA=0.230, N-BK7 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al75150';
lens.name = 'AL75150-A';
lens.diam = [ 75, 66.80471428272 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0130412102243088, 0 ];
lens.tc = [ 15 ];
lens.conj = [ inf, 140.0788998628];
lens.conjcurv = [ 0, 0];
