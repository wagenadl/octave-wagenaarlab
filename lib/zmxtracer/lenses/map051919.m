function lens = map051919
% ZMX/MAP051919-A.ZMX - 1/2 Inch Matched Achromatic Pair, Magnification: 1.00:1.00

lens.fn = 'map051919';
lens.name = 'MAP051919-A';
lens.diam = [ 12.7, 12.7, 12.7, 10.123032557732, 12.7, 12.7, 12.7 ];
lens.glass = { @nsf6ht, @nbaf10, @(x) (1), @(x) (1), @nbaf10, @nsf6ht };
lens.curv = [ 0.0168747890651367, 0.0905797101449276, -0.0772797527047913, 0, 0.0772797527047913, -0.0905797101449276, -0.0168747890651367 ];
lens.tc = [ 1.5, 4.5, 1.998703018339, 1.99470363593, 4.5, 1.5 ];
lens.conj = [ 15.70937859976, 15.28153043766];
lens.conjcurv = [ 0, 0];
