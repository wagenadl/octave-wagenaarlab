function lens = map052550
% ZEMAX/THORLABS/ZMX/MAP052550-A.ZMX - 1/2 Inch Matched Achromatic Pair, Magnification: 1.00:2.00

lens.fn = 'map052550';
lens.name = 'MAP052550-A';
lens.diam = [ 12.7, 12.7, 12.7, 10.438985128026, 12.7, 12.7, 12.7 ];
lens.glass = { @sf10, @nbaf10, @(x) (1), @(x) (1), @nbk7, @sf2 };
lens.curv = [ 0.0146886016451234, 0.0944287063267233, -0.0532197977647685, 0, 0.0365497076023392, -0.0443655723158829, -0.0108896874659697 ];
lens.tc = [ 2, 5, 1.996594117465, 1.997773137827, 3.5, 1.5 ];
lens.conj = [ 21.55201721576, 45.89777841373];
lens.conjcurv = [ 0, 0];
