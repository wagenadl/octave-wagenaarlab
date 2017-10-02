function lens = al2520b
% ZMX/AL2520-B.ZMX - Ø25 mm, f=20 mm, NA=0.543, S-LAH64 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al2520b';
lens.name = 'AL2520-B';
lens.diam = [ 25, 20.35040873524 ];
lens.glass = { @slah64 };
lens.curv = [ 0.0643500643500644, 0 ];
lens.tc = [ 7.6 ];
lens.conj = [ inf, 15.72601211869];
lens.conjcurv = [ 0, 0];
