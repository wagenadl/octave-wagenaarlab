function lens = al1815
% ZMX/AL1815-A.ZMX - Ø18 mm, f=15 mm, NA=0.534, S-LAH64 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al1815';
lens.name = 'AL1815-A';
lens.diam = [ 18, 14.516314450224 ];
lens.glass = { @slah64 };
lens.curv = [ 0.0858369098712446, 0 ];
lens.tc = [ 6.2 ];
lens.conj = [ inf, 11.50668035421];
lens.conjcurv = [ 0, 0];
