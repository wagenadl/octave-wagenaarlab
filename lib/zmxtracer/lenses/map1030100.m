function lens = map1030100
% ZMX/MAP1030100-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:3.33

lens.fn = 'map1030100';
lens.name = 'MAP1030100-A';
lens.diam = [ 25.4, 25.4, 25.4, 18.980133541452, 25.4, 25.4, 25.4 ];
lens.glass = { @nsf6ht, @nbaf10, @(x) (1), @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0.012531328320802, 0.0597728631201435, -0.0478697941598851, 0, 0.0159362549800797, -0.0218770509735288, -0.0077984870935039 ];
lens.tc = [ 2, 12, 1.990003394648, 1.979476699638, 4, 2.5 ];
lens.conj = [ 22.35418869071, 87.92439095934];
lens.conjcurv = [ 0, 0];
