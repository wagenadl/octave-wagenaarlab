function lens = ld2746b
% ZMX/LD2746-B.ZMX - LD2746 Bi-Concave - N-SF11

lens.fn = 'ld2746b';
lens.name = 'LD2746-B';
lens.diam = [ 6, 6 ];
lens.glass = { @nsf11 };
lens.curv = [ -0.10351966873706, 0.10351966873706 ];
lens.tc = [ 1.5 ];
lens.conj = [ inf, -5.301036040955];
lens.conjcurv = [ 0, 0];
