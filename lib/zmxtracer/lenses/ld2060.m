function lens = ld2060
% ZEMAX/THORLABS/ZMX/LD2060-A.ZMX - LD2060 Bi-Concave - N-SF11

lens.fn = 'ld2060';
lens.name = 'LD2060-A';
lens.diam = [ 12.7, 12.7 ];
lens.glass = { @nsf11 };
lens.curv = [ -0.0416840350145894, 0.0416840350145894 ];
lens.tc = [ 3 ];
lens.conj = [ inf, -13.82526826274];
lens.conjcurv = [ 0, 0];
