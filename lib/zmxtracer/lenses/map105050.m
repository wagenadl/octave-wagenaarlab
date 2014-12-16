function lens = map105050
% ZEMAX/THORLABS/ZMX/MAP105050-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:1.00

lens.fn = 'map105050';
lens.name = 'MAP105050-A';
lens.diam = [ 25.4, 25.4, 25.4, 20.64589190848, 25.4, 25.4, 25.4 ];
lens.glass = { @sf10, @nbaf10, @(x) (1), @(x) (1), @nbaf10, @sf10 };
lens.curv = [ 0.0034355996839248, 0.0448833034111311, -0.02999400119976, 0, 0.02999400119976, -0.0448833034111311, -0.0034355996839248 ];
lens.tc = [ 2.5, 9, 1.999963641946, 1.999494107216, 9, 2.5 ];
lens.conj = [ 42.92641951733, 43.15779576656];
lens.conjcurv = [ 0, 0];
