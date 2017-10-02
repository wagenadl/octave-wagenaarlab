function lens = map051925
% ZMX/MAP051925-A.ZMX - 1/2 Inch Matched Achromatic Pair, Magnification: 1.00:1.32

lens.fn = 'map051925';
lens.name = 'MAP051925-A';
lens.diam = [ 12.7, 12.7, 12.7, 9.546232335632, 12.7, 12.7, 12.7 ];
lens.glass = { @nsf6ht, @nbaf10, @(x) (1), @(x) (1), @nbaf10, @sf10 };
lens.curv = [ 0.0168747890651367, 0.0905797101449276, -0.0772797527047913, 0, 0.0532197977647685, -0.0944287063267233, -0.0146886016451234 ];
lens.tc = [ 1.5, 4.5, 1.999114873853, 1.999726874054, 5, 2 ];
lens.conj = [ 15.73154474143, 20.86844946155];
lens.conjcurv = [ 0, 0];
