function lens = ac254500b
% ZMX/AC254-500-B.ZMX - AC254-500-B NEAR IR ACHROMATS: Infinite Conjugate 500

lens.fn = 'ac254500b';
lens.name = 'AC254-500-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @sf10, @nsf6ht };
lens.curv = [ 0.0165016501650165, -0.0159362549800797, 0.0114194358798675 ];
lens.tc = [ 4, 2 ];
lens.conj = [ inf, 480.6974362076];
lens.conjcurv = [ 0, 0];
