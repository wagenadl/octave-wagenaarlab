function lens = ac080016
% ZEMAX/THORLABS/ZMX/AC080-016-A.ZMX - AC080-016-A POSITIVE VISIBLE ACHROMATS: Infinite 16

lens.fn = 'ac080016';
lens.name = 'AC080-016-A';
lens.diam = [ 8, 8, 8 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0907441016333938, -0.108695652173913, -0.021381227282446 ];
lens.tc = [ 2.5, 1.5 ];
lens.conj = [ inf, 13.85755376779];
lens.conjcurv = [ 0, 0];
