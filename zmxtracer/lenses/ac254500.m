function lens = ac254500
% ZMX/AC254-500-A.ZMX - AC254-500-A POSITIVE VISIBLE ACHROMATS: Infinite 500

lens.fn = 'ac254500';
lens.name = 'AC254-500-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbk7, @sf2 };
lens.curv = [ 0.0029647198339757, -0.0053547523427041, -0.0017940437746681 ];
lens.tc = [ 4, 2 ];
lens.conj = [ inf, 500.1654278455];
lens.conjcurv = [ 0, 0];
