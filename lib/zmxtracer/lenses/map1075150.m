function lens = map1075150
% ZEMAX/THORLABS/ZMX/MAP1075150-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:2.00

lens.fn = 'map1075150';
lens.name = 'MAP1075150-A';
lens.diam = [ 25.4, 25.4, 25.4, 21.09548072544, 25.4, 25.4, 25.4 ];
lens.glass = { @sf5, @nbk7, @(x) (1), @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0.0104668201800293, 0.0294898260100265, -0.0214868929952729, 0, 0.0109146474568871, -0.01499700059988, -0.0050581689428427 ];
lens.tc = [ 2.5, 7, 0.9032594422423, 2.000000020271, 5.7, 2.2 ];
lens.conj = [ 71.22165270963, 140.619289112];
lens.conjcurv = [ 0, 0];
