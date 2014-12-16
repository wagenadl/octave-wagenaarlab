function lens = ac254400
% ZEMAX/THORLABS/ZMX/AC254-400-A.ZMX - AC254-400-A POSITIVE VISIBLE ACHROMATS: Infinite 400

lens.fn = 'ac254400';
lens.name = 'AC254-400-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbk7, @sf2 };
lens.curv = [ 0.0045495905368517, -0.0055081244836133, -0.001354096140826 ];
lens.tc = [ 4, 2 ];
lens.conj = [ inf, 396.0828048761];
lens.conjcurv = [ 0, 0];
