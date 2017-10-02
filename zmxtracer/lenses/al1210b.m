function lens = al1210b
% ZMX/AL1210-B.ZMX - Ø12.5 mm, f=10 mm, NA=0.545, S-LAH64 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al1210b';
lens.name = 'AL1210-B';
lens.diam = [ 12.5, 9.88443522352 ];
lens.glass = { @slah64 };
lens.curv = [ 0.128700128700129, 0 ];
lens.tc = [ 4.25 ];
lens.conj = [ inf, 7.609752392179];
lens.conjcurv = [ 0, 0];
