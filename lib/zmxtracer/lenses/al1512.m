function lens = al1512
% ZEMAX/THORLABS/ZMX/AL1512-A.ZMX - Ø15 mm, f=12 mm, NA=0.546, S-LAH64 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al1512';
lens.name = 'AL1512-A';
lens.diam = [ 15, 11.744556415026 ];
lens.glass = { @slah64 };
lens.curv = [ 0.107296137339056, 0 ];
lens.tc = [ 5.28 ];
lens.conj = [ inf, 9.025253009263];
lens.conjcurv = [ 0, 0];
