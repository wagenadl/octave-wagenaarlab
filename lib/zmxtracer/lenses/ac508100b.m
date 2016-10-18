function lens = ac508100b
% ZMX/AC508-100-B.ZMX - AC508-100-B NEAR IR ACHROMATS: Infinite Conjugate 100

lens.fn = 'ac508100b';
lens.name = 'AC508-100-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0152045005321575, -0.0178635226866738, -0.0035644270183568 ];
lens.tc = [ 13, 2 ];
lens.conj = [ inf, 91.18034738546];
lens.conjcurv = [ 0, 0];
