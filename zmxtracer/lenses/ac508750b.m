function lens = ac508750b
% ZMX/AC508-750-B.ZMX - AC508-750-B NEAR IR ACHROMATS: Infinite Conjugate 750

lens.fn = 'ac508750b';
lens.name = 'AC508-750-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nbaf10, @sf10 };
lens.curv = [ 0.0026539278131635, -0.0034355996839248, 0.0003436426116838 ];
lens.tc = [ 4.2, 2.5 ];
lens.conj = [ inf, 745.2739390049];
lens.conjcurv = [ 0, 0];
