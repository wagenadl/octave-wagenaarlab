function lens = map107575
% ZEMAX/THORLABS/ZMX/MAP107575-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:1.00

lens.fn = 'map107575';
lens.name = 'MAP107575-A';
lens.diam = [ 25.4, 25.4, 25.4, 20.47423779294, 25.4, 25.4, 25.4 ];
lens.glass = { @sf5, @nbk7, @(x) (1), @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0.0104668201800293, 0.0294898260100265, -0.0214868929952729, 0, 0.0214868929952729, -0.0294898260100265, -0.0104668201800293 ];
lens.tc = [ 2.5, 7, 3.074044130493, 2.999296966073, 7, 2.5 ];
lens.conj = [ 69.99824637003, 69.81617680137];
lens.conjcurv = [ 0, 0];
