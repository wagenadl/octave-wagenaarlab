function lens = al5040b
% ZMX/AL5040-B.ZMX - Ø50 mm, f=40 mm, NA=0.554, S-LAH64 Aspheric Lens, ARC: 650-1050 nm

lens.fn = 'al5040b';
lens.name = 'AL5040-B';
lens.diam = [ 50, 41.66976358182 ];
lens.glass = { @slah64 };
lens.curv = [ 0.0321802091713596, 0 ];
lens.tc = [ 15.5 ];
lens.conj = [ inf, 31.27675290385];
lens.conjcurv = [ 0, 0];
