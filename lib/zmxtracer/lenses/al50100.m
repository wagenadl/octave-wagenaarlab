function lens = al50100
% ZEMAX/THORLABS/ZMX/AL50100-A.ZMX - Ø50 mm, f=100 mm, NA=0.240, N-BK7 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al50100';
lens.name = 'AL50100-A';
lens.diam = [ 50, 45.57890008584 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0195618153364632, 0 ];
lens.tc = [ 10 ];
lens.conj = [ inf, 93.3859313897];
lens.conjcurv = [ 0, 0];
