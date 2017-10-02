function lens = map103075
% ZMX/MAP103075-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:2.50

lens.fn = 'map103075';
lens.name = 'MAP103075-A';
lens.diam = [ 25.4, 25.4, 25.4, 18.97802925059, 25.4, 25.4, 25.4 ];
lens.glass = { @nsf6ht, @nbaf10, @(x) (1), @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0.012531328320802, 0.0597728631201435, -0.0478697941598851, 0, 0.0214868929952729, -0.0294898260100265, -0.0104668201800293 ];
lens.tc = [ 2, 12, 1.993340729064, 1.99998724667, 7, 2.5 ];
lens.conj = [ 22.22828382894, 65.60483453474];
lens.conjcurv = [ 0, 0];
