function lens = ac254050
% ZEMAX/THORLABS/ZMX/AC254-050-A.ZMX - AC254-050-A POSITIVE VISIBLE ACHROMATS: Infinite 50

lens.fn = 'ac254050';
lens.name = 'AC254-050-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @sf10 };
lens.curv = [ 0.02999400119976, -0.0448833034111311, -0.0034355996839248 ];
lens.tc = [ 9, 2.5 ];
lens.conj = [ inf, 43.22018758686];
lens.conjcurv = [ 0, 0];
