function lens = ac254050b
% ZMX/AC254-050-B.ZMX - AC254-050-B NEAR IR ACHROMATS: Infinite Conjugate 50

lens.fn = 'ac254050b';
lens.name = 'AC254-050-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.029806259314456, -0.0369685767097967, -0.0079617834394904 ];
lens.tc = [ 7.5, 1.8 ];
lens.conj = [ inf, 44.81190496001];
lens.conjcurv = [ 0, 0];
