function lens = map1040100
% ZEMAX/THORLABS/ZMX/MAP1040100-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:2.50

lens.fn = 'map1040100';
lens.name = 'MAP1040100-A';
lens.diam = [ 25.4, 25.4, 25.4, 19.326679660606, 25.4, 25.4, 25.4 ];
lens.glass = { @sf5, @nbk7, @(x) (1), @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0.0173370319001387, 0.0497760079641613, -0.0422654268808115, 0, 0.0159362549800797, -0.0218770509735288, -0.0077984870935039 ];
lens.tc = [ 2.5, 10, 1.99827777869, 1.998946919237, 4, 2.5 ];
lens.conj = [ 33.35079332648, 92.37008166469];
lens.conjcurv = [ 0, 0];
