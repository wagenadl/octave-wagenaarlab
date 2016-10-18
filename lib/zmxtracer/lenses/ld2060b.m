function lens = ld2060b
% ZMX/LD2060-B.ZMX - LD2060 Bi-Concave - N-SF11

lens.fn = 'ld2060b';
lens.name = 'LD2060-B';
lens.diam = [ 12.7, 12.7 ];
lens.glass = { @nsf11 };
lens.curv = [ -0.0416840350145894, 0.0416840350145894 ];
lens.tc = [ 3 ];
lens.conj = [ inf, -13.82526826274];
lens.conjcurv = [ 0, 0];
