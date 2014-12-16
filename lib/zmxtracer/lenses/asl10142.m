function lens = asl10142
% ZEMAX/THORLABS/ZMX/ASL10142.ZMX - 1" Aspheric Lens, DW=780nm, NA=0.14, f=79.0mm, Uncoated

lens.fn = 'asl10142';
lens.name = 'ASL10142';
lens.diam = [ 22.86, 25.4, 25.4 ];
lens.glass = { @(x) (1), @c7980 };
lens.curv = [ 0, 0.0279129637029301, 0 ];
lens.tc = [ 2, 6 ];
lens.conj = [ inf, 74.84143302358];
lens.conjcurv = [ 0, 0];