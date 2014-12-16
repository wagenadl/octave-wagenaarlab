function lens = map103050
% ZEMAX/THORLABS/ZMX/MAP103050-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:1.67

lens.fn = 'map103050';
lens.name = 'MAP103050-A';
lens.diam = [ 25.4, 25.4, 25.4, 18.335018012526, 25.4, 25.4, 25.4 ];
lens.glass = { @nsf6ht, @nbaf10, @(x) (1), @(x) (1), @nbaf10, @sf10 };
lens.curv = [ 0.012531328320802, 0.0597728631201435, -0.0478697941598851, 0, 0.02999400119976, -0.0448833034111311, -0.0034355996839248 ];
lens.tc = [ 2, 12, 2.999854434136, 2.479503862896, 9, 2.5 ];
lens.conj = [ 22.31475984201, 40.89973349155];
lens.conjcurv = [ 0, 0];
