function lens = ac5081000b
% ZMX/AC508-1000-B.ZMX - AC508-1000-B NEAR IR ACHROMATS: Infinite Conjugate1000

lens.fn = 'ac5081000b';
lens.name = 'AC508-1000-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nbaf10, @sf10 };
lens.curv = [ 0.0020230629172567, -0.0025119316754584, 0.0002906976744186 ];
lens.tc = [ 4.2, 2.8 ];
lens.conj = [ inf, 993.9464603531];
lens.conjcurv = [ 0, 0];
