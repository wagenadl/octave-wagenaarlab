function lens = acn127050b
% ZMX/ACN127-050-B.ZMX - ACN127-050-B NEAR IR NEGATIVE ACHROMATS: Infinite -50

lens.fn = 'acn127050b';
lens.name = 'ACN127-050-B';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ -0.0409332787556283, 0.0328839197632358, -0.0034355996839248 ];
lens.tc = [ 1.5, 2 ];
lens.conj = [ inf, -52.51322064027];
lens.conjcurv = [ 0, 0];
