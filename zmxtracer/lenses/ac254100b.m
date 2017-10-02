function lens = ac254100b
% ZMX/AC254-100-B.ZMX - AC254-100-B NEAR IR ACHROMATS: Infinite Conjugate 100

lens.fn = 'ac254100b';
lens.name = 'AC254-100-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.01499700059988, -0.0186219739292365, -0.0038549015072665 ];
lens.tc = [ 4, 1.5 ];
lens.conj = [ inf, 97.09139603884];
lens.conjcurv = [ 0, 0];
