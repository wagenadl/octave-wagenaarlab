function lens = acn127025b
% ZMX/ACN127-025-B.ZMX - ACN127-025-B NEAR IR NEGATIVE ACHROMATS: Infinite -25

lens.fn = 'acn127025b';
lens.name = 'ACN127-025-B';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ -0.0736377025036819, 0.0583771161704612, -0.0011641443538999 ];
lens.tc = [ 1.5, 2.8 ];
lens.conj = [ inf, -27.63663269244];
lens.conjcurv = [ 0, 0];
