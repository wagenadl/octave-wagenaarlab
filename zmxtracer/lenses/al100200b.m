function lens = al100200b
% ZMX/AL100200-B.ZMX - Ø100 mm, f=200 mm, NA=0.230, N-BK7 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al100200b';
lens.name = 'AL100200-B';
lens.diam = [ 100, 89.38366259756 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.00978090766823161, 0 ];
lens.tc = [ 19 ];
lens.conj = [ inf, 187.4335980205];
lens.conjcurv = [ 0, 0];
