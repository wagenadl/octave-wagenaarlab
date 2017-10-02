function lens = acn254100b
% ZMX/ACN254-100-B.ZMX - ACN254-100-B NEAR IR NEGATIVE ACHROMATS: Infinite -100

lens.fn = 'acn254100b';
lens.name = 'ACN254-100-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ -0.0205128205128205, 0.0169434090138936, -0.0017217630853994 ];
lens.tc = [ 2, 3.4 ];
lens.conj = [ inf, -103.8953031265];
lens.conjcurv = [ 0, 0];
