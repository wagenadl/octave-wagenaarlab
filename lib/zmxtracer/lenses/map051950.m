function lens = map051950
% ZEMAX/THORLABS/ZMX/MAP051950-A.ZMX - 1/2 Inch Matched Achromatic Pair, Magnification: 1.00:2.63

lens.fn = 'map051950';
lens.name = 'MAP051950-A';
lens.diam = [ 12.7, 12.7, 12.7, 9.79596679115, 12.7, 12.7, 12.7 ];
lens.glass = { @nsf6ht, @nbaf10, @(x) (1), @(x) (1), @nbk7, @sf2 };
lens.curv = [ 0.0168747890651367, 0.0905797101449276, -0.0772797527047913, 0, 0.0365497076023392, -0.0443655723158829, -0.0108896874659697 ];
lens.tc = [ 1.5, 4.5, 1.999999984749, 1.983312228833, 3.5, 1.5 ];
lens.conj = [ 16.34115676015, 41.73046895115];
lens.conjcurv = [ 0, 0];
