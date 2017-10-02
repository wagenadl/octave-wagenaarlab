function lens = al50100b
% ZMX/AL50100-B.ZMX - Ø50 mm, f=100 mm, NA=0.240, N-BK7 Aspheric Lens, ARC: 650-1620 nm

lens.fn = 'al50100b';
lens.name = 'AL50100-B';
lens.diam = [ 50, 45.57890008584 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0195618153364632, 0 ];
lens.tc = [ 10 ];
lens.conj = [ inf, 93.3859313897];
lens.conjcurv = [ 0, 0];
