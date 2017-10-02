function lens = ac254045b
% ZMX/AC254-045-B.ZMX - AC254-045-B NEAR IR ACHROMATS: Infinite Conjugate 45

lens.fn = 'ac254045b';
lens.name = 'AC254-045-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0340367597004765, -0.0399201596806387, -0.0078702974972454 ];
lens.tc = [ 7.8, 1.6 ];
lens.conj = [ inf, 39.41122919145];
lens.conjcurv = [ 0, 0];
