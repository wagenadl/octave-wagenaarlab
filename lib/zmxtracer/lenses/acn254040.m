function lens = acn254040
% ZEMAX/THORLABS/ZMX/ACN254-040-A.ZMX - ACN254-040-A NEGATIVE VISIBLE ACHROMATS: Infinite-40

lens.fn = 'acn254040';
lens.name = 'ACN254-040-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf11 };
lens.curv = [ -0.0369685767097967, 0.0369685767097967, 0.0052845743275379 ];
lens.tc = [ 2, 5 ];
lens.conj = [ inf, -43.21693335291];
lens.conjcurv = [ 0, 0];
