function lens = acn127050
% ZEMAX/THORLABS/ZMX/ACN127-050-A.ZMX - ACN127-050-A NEGATIVE VISIBLE ACHROMATS: Infinite-50

lens.fn = 'acn127050';
lens.name = 'ACN127-050-A';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nbak4, @sf5 };
lens.curv = [ -0.0391389432485323, 0.0391389432485323, 0.0026831231553528 ];
lens.tc = [ 1.5, 2.2 ];
lens.conj = [ inf, -52.24114133693];
lens.conjcurv = [ 0, 0];
