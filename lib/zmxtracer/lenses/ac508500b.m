function lens = ac508500b
% ZMX/AC508-500-B.ZMX - AC508-500-B NEAR IR ACHROMATS: Infinite Conjugate 500

lens.fn = 'ac508500b';
lens.name = 'AC508-500-B';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0028843380444188, -0.0038549015072665, -0.0008830801836807 ];
lens.tc = [ 4.5, 2.6 ];
lens.conj = [ inf, 497.1313766111];
lens.conjcurv = [ 0, 0];
