function lens = al2018b
% ZMX/AL2018-B.ZMX - Ø20 mm, f=18 mm, NA=0.488, S-LAH64 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al2018b';
lens.name = 'AL2018-B';
lens.diam = [ 20, 15.658265241468 ];
lens.glass = { @slah64 };
lens.curv = [ 0.0715307582260372, 0 ];
lens.tc = [ 7.1 ];
lens.conj = [ inf, 13.99936341915];
lens.conjcurv = [ 0, 0];
