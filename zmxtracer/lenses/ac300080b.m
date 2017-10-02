function lens = ac300080b
% ZMX/AC300-080-B.ZMX - AC300-080-B NEAR IR ACHROMATS: Infinite Conjugate 80

lens.fn = 'ac300080b';
lens.name = 'AC300-080-B';
lens.diam = [ 30, 30, 30 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0190548780487805, -0.0234246896228625, -0.0046232085067037 ];
lens.tc = [ 6.5, 2 ];
lens.conj = [ inf, 75.30270214059];
lens.conjcurv = [ 0, 0];
