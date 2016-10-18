function lens = al4532b
% ZMX/AL4532-B.ZMX - Ø45 mm, f=32 mm, NA=0.612, S-LAH64 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al4532b';
lens.name = 'AL4532-B';
lens.diam = [ 45, 37.3695107384 ];
lens.glass = { @slah64 };
lens.curv = [ 0.0402252614641995, 0 ];
lens.tc = [ 13.9 ];
lens.conj = [ inf, 24.17728426372];
lens.conjcurv = [ 0, 0];
