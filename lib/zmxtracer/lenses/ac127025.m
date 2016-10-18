function lens = ac127025
% ZMX/AC127-025-A.ZMX - AC127-025-A POSITIVE VISIBLE ACHROMATS: Infinite 25

lens.fn = 'ac127025';
lens.name = 'AC127-025-A';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nbaf10, @sf10 };
lens.curv = [ 0.0532197977647685, -0.0944287063267233, -0.0146886016451234 ];
lens.tc = [ 5, 2 ];
lens.conj = [ inf, 21.36034447321];
lens.conjcurv = [ 0, 0];
