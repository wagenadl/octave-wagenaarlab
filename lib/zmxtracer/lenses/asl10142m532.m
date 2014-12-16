function lens = asl10142m532
% ZEMAX/THORLABS/ZMX/ASL10142M-532.ZMX - Mounted 1" Aspheric Lens, NA=0.145, DW=780nm, 532nm VARC, f=77.8mm at 532nm

lens.fn = 'asl10142m532';
lens.name = 'ASL10142M-532';
lens.diam = [ 22.86, 25.4, 25.4 ];
lens.glass = { @(x) (1), @c7980 };
lens.curv = [ 0, 0.0279129637029301, 0 ];
lens.tc = [ 2, 6 ];
lens.conj = [ inf, 73.65610433419];
lens.conjcurv = [ 0, 0];
