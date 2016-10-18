function lens = map105075
% ZMX/MAP105075-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:1.50

lens.fn = 'map105075';
lens.name = 'MAP105075-A';
lens.diam = [ 25.4, 25.4, 25.4, 20.2002147742, 25.4, 25.4, 25.4 ];
lens.glass = { @sf10, @nbaf10, @(x) (1), @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0.0034355996839248, 0.0448833034111311, -0.02999400119976, 0, 0.0214868929952729, -0.0294898260100265, -0.0104668201800293 ];
lens.tc = [ 2.5, 9, 3.087416249991, 2.999999995805, 7, 2.5 ];
lens.conj = [ 43.21053175751, 69.51053993446];
lens.conjcurv = [ 0, 0];
