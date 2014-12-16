function lens = ac254200
% ZEMAX/THORLABS/ZMX/AC254-200-A.ZMX - AC254-200-A POSITIVE VISIBLE ACHROMATS: Infinite 200

lens.fn = 'ac254200';
lens.name = 'AC254-200-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nssk5, @lafn7 };
lens.curv = [ 0.0129198966408269, -0.0114194358798675, 0.0034355996839248 ];
lens.tc = [ 4, 2.5 ];
lens.conj = [ inf, 193.9545396167];
lens.conjcurv = [ 0, 0];
