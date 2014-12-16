function lens = acn254050
% ZEMAX/THORLABS/ZMX/ACN254-050-A.ZMX - ACN254-050-A NEGATIVE VISIBLE ACHROMATS: Infinite-50

lens.fn = 'acn254050';
lens.name = 'ACN254-050-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ -0.0294464075382803, 0.0307597662257767, 0.0052845743275379 ];
lens.tc = [ 2, 4.5 ];
lens.conj = [ inf, -52.88445773232];
lens.conjcurv = [ 0, 0];
