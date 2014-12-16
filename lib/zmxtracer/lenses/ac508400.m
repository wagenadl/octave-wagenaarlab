function lens = ac508400
% ZEMAX/THORLABS/ZMX/AC508-400-A.ZMX - AC508-400-A POSITIVE VISIBLE ACHROMATS: Infinite 400

lens.fn = 'ac508400';
lens.name = 'AC508-400-A';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nbk7, @sf2 };
lens.curv = [ 0.0045495905368517, -0.0053547523427041, -0.0013157894736842 ];
lens.tc = [ 5, 2 ];
lens.conj = [ inf, 396.1327251284];
lens.conjcurv = [ 0, 0];
