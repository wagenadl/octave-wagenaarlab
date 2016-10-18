function lens = al1225
% ZMX/AL1225-A.ZMX - Ø12.5 mm, f=25 mm, NA=0.230, N-BK7 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al1225';
lens.name = 'AL1225-A';
lens.diam = [ 12.5, 10.418905446106 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0782472613458529, 0 ];
lens.tc = [ 4 ];
lens.conj = [ inf, 22.35388375085];
lens.conjcurv = [ 0, 0];
