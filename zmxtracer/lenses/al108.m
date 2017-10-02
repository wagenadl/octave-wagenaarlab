function lens = al108
% ZMX/AL108-A.ZMX - AL108=A Ø10 mm, f=8 mm, NA=0.547, S-LAH64 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al108';
lens.name = 'AL108-A';
lens.diam = [ 10, 7.711183901228 ];
lens.glass = { @slah64 };
lens.curv = [ 0.160901045856798, 0 ];
lens.tc = [ 3.7 ];
lens.conj = [ inf, 5.908362263035];
lens.conjcurv = [ 0, 0];
