function lens = ac254080
% ZEMAX/THORLABS/ZMX/AC254-080-A.ZMX - Ø25.4 mm, f=80.0 mm, Near IR Achromat, ARC: 350-700 nm

lens.fn = 'ac254080';
lens.name = 'AC254-080-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbk7, @nsf5 };
lens.curv = [ 0.0201674093560917, -0.0281407052051299, -0.00988193148681039 ];
lens.tc = [ 7.00048775857, 2.999769679963 ];
lens.conj = [ inf, 75.25783536578];
lens.conjcurv = [ 0, 0];
