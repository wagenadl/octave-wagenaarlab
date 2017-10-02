function lens = acn127030b
% ZMX/ACN127-030-B.ZMX - ACN127-030-B NEAR IR NEGATIVE ACHROMATS: Infinite -30

lens.fn = 'acn127030b';
lens.name = 'ACN127-030-B';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ -0.051948051948052, 0.0543183052688756, 0.0093976130062964 ];
lens.tc = [ 1.5, 2.5 ];
lens.conj = [ inf, -31.95775200249];
lens.conjcurv = [ 0, 0];
