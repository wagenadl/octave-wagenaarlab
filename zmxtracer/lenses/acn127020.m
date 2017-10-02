function lens = acn127020
% ZMX/ACN127-020-A.ZMX - ACN127-020-A NEGATIVE VISIBLE ACHROMATS: Infinite-20

lens.fn = 'acn127020';
lens.name = 'ACN127-020-A';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ -0.073909830007391, 0.0701754385964912, 0.0113765642775882 ];
lens.tc = [ 1.5, 3 ];
lens.conj = [ inf, -22.10601009245];
lens.conjcurv = [ 0, 0];
