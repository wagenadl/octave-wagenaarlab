function lens = ac254080b
% ZMX/AC254-080-B.ZMX - Ø25.4 mm, f=80.0 mm, Near IR Achromat, ARC: 650 - 1050 nm

lens.fn = 'ac254080b';
lens.name = 'AC254-080-B';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0258599387891729, -0.0231460705199755, 0.00267401402388739 ];
lens.tc = [ 6.582144861689, 2.027306446738 ];
lens.conj = [ inf, 73.51537935593];
lens.conjcurv = [ 0, 0];
