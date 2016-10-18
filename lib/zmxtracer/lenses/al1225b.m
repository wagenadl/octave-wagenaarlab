function lens = al1225b
% ZMX/AL1225-B.ZMX - Ø12.5 mm, f=25 mm, NA=0.230, N-BK7 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al1225b';
lens.name = 'AL1225-B';
lens.diam = [ 12.5, 10.418905446106 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0782472613458529, 0 ];
lens.tc = [ 4 ];
lens.conj = [ inf, 22.35388375085];
lens.conjcurv = [ 0, 0];
