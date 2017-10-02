function lens = ac300050
% ZMX/AC300-050-A.ZMX - AC300-050-A POSITIVE VISIBLE ACHROMATS: Infinite 50

lens.fn = 'ac300050';
lens.name = 'AC300-050-A';
lens.diam = [ 30, 30, 30 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0293772032902468, -0.0340367597004765, -0.0061919504643963 ];
lens.tc = [ 8.5, 2 ];
lens.conj = [ inf, 43.92869947961];
lens.conjcurv = [ 0, 0];
