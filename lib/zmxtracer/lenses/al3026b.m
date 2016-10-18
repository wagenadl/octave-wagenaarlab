function lens = al3026b
% ZMX/AL3026-B.ZMX - Ø30 mm, f=26 mm, NA=0.522, S-LAH64 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al3026b';
lens.name = 'AL3026-B';
lens.diam = [ 30, 25.17227206826 ];
lens.glass = { @slah64 };
lens.curv = [ 0.0495049504950495, 0 ];
lens.tc = [ 9.65 ];
lens.conj = [ inf, 20.57068194965];
lens.conjcurv = [ 0, 0];
