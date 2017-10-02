function lens = ac080020
% ZMX/AC080-020-A.ZMX - AC080-020-A POSITIVE VISIBLE ACHROMATS: Infinite 20

lens.fn = 'ac080020';
lens.name = 'AC080-020-A';
lens.diam = [ 8, 8, 8 ];
lens.glass = { @nbk7, @sf2 };
lens.curv = [ 0.0902527075812274, -0.108695652173913, -0.0287108814240597 ];
lens.tc = [ 2.5, 1.5 ];
lens.conj = [ inf, 17.76235251425];
lens.conjcurv = [ 0, 0];
