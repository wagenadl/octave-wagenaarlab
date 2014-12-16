function lens = map104040
% ZEMAX/THORLABS/ZMX/MAP104040-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:1.00

lens.fn = 'map104040';
lens.name = 'MAP104040-A';
lens.diam = [ 25.4, 25.4, 25.4, 19.325922172944, 25.4, 25.4, 25.4 ];
lens.glass = { @sf5, @nbk7, @(x) (1), @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0.0173370319001387, 0.0497760079641613, -0.0422654268808115, 0, 0.0422654268808115, -0.0497760079641613, -0.0173370319001387 ];
lens.tc = [ 2.5, 10, 1.999769574204, 1.99977997924, 10, 2.5 ];
lens.conj = [ 33.3577438673, 31.97859930446];
lens.conjcurv = [ 0, 0];
