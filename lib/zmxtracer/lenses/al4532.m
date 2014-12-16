function lens = al4532
% ZEMAX/THORLABS/ZMX/AL4532-A.ZMX - Ø45 mm, f=32 mm, NA=0.612, S-LAH64 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al4532';
lens.name = 'AL4532-A';
lens.diam = [ 45, 37.3695107384 ];
lens.glass = { @slah64 };
lens.curv = [ 0.0402252614641995, 0 ];
lens.tc = [ 13.9 ];
lens.conj = [ inf, 24.17728426372];
lens.conjcurv = [ 0, 0];
