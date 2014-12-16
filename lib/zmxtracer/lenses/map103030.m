function lens = map103030
% ZEMAX/THORLABS/ZMX/MAP103030-A.ZMX - 1 Inch Matched Achromatic Pair, Magnification: 1.00:1.00

lens.fn = 'map103030';
lens.name = 'MAP103030-A';
lens.diam = [ 25.4, 25.4, 25.4, 18.989312501046, 25.4, 25.4, 25.4 ];
lens.glass = { @nsf6ht, @nbaf10, @(x) (1), @(x) (1), @nbaf10, @nsf6ht };
lens.curv = [ 0.012531328320802, 0.0597728631201435, -0.0478697941598851, 0, 0.0478697941598851, -0.0597728631201435, -0.0125297918147045 ];
lens.tc = [ 2, 12, 2.999827210261, 2.999994579028, 12, 2 ];
lens.conj = [ 21.97678364717, 21.08569129994];
lens.conjcurv = [ 0, 0];
