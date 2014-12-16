function lens = al2520
% ZEMAX/THORLABS/ZMX/AL2520-A.ZMX - Ø25 mm, f=20 mm, NA=0.543, S-LAH64 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al2520';
lens.name = 'AL2520-A';
lens.diam = [ 25, 20.35040873524 ];
lens.glass = { @slah64 };
lens.curv = [ 0.0643500643500644, 0 ];
lens.tc = [ 7.6 ];
lens.conj = [ inf, 15.72601211869];
lens.conjcurv = [ 0, 0];
