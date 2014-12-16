function lens = ac050010
% ZEMAX/THORLABS/ZMX/AC050-010-A.ZMX - AC050-010-A POSITIVE VISIBLE ACHROMATS: Infinite 10

lens.fn = 'ac050010';
lens.name = 'AC050-010-A';
lens.diam = [ 5, 5, 5 ];
lens.glass = { @nbak4, @sf5 };
lens.curv = [ 0.152671755725191, -0.235294117647059, -0.0648508430609598 ];
lens.tc = [ 2.5, 1.9 ];
lens.conj = [ inf, 7.828794090553];
lens.conjcurv = [ 0, 0];
