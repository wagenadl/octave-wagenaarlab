function lens = ac254030
% ZEMAX/THORLABS/ZMX/AC254-030-A.ZMX - AC254-030-A POSITIVE VISIBLE ACHROMATS: Infinite 30

lens.fn = 'ac254030';
lens.name = 'AC254-030-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0478697941598851, -0.0597728631201435, -0.012531328320802 ];
lens.tc = [ 12, 2 ];
lens.conj = [ inf, 21.68759218317];
lens.conjcurv = [ 0, 0];
