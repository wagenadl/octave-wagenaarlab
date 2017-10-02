function lens = map103040
% ZMX/MAP103040-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:1.33

lens.fn = 'map103040';
lens.name = 'MAP103040-A';
lens.diam = [ 25.4, 25.4, 25.4, 19.646517099106, 25.4, 25.4, 25.4 ];
lens.glass = { @nsf6ht, @nbaf10, @(x) (1), @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0.012531328320802, 0.0597728631201435, -0.0478697941598851, 0, 0.0422654268808115, -0.0497760079641613, -0.0173370319001387 ];
lens.tc = [ 2, 12, 1.999242836875, 1.999995578229, 10, 2.5 ];
lens.conj = [ 22.42395853322, 31.0952703136];
lens.conjcurv = [ 0, 0];
