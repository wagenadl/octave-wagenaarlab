function lens = ac254040b
% ZMX/AC254-040-B.ZMX - AC254-040-B NEAR IR ACHROMATS: Infinite Conjugate 40

lens.fn = 'ac254040b';
lens.name = 'AC254-040-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0382848392036753, -0.0469924812030075, -0.0072944780800934 ];
lens.tc = [ 10, 2.5 ];
lens.conj = [ inf, 32.59974238736];
lens.conjcurv = [ 0, 0];
