function lens = al100100
% ZEMAX/THORLABS/ZMX/AL100100-A.ZMX - Ø100 mm, f=100 mm, NA=0.478, N-BK7 Aspheric Lens, ARC: 350-700 nm

lens.fn = 'al100100';
lens.name = 'AL100100-A';
lens.diam = [ 100, 83.23377015894 ];
lens.glass = { @nbk7 };
lens.curv = [ 0.0195618153364632, 0 ];
lens.tc = [ 36 ];
lens.conj = [ inf, 76.18087196788];
lens.conjcurv = [ 0, 0];
