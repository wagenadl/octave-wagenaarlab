function lens = ac254125
% ZMX/AC254-125-A.ZMX - Ø25.4 mm, f=125.0 mm, Near IR Achromat, ARC: 350-700 nm

lens.fn = 'ac254125';
lens.name = 'AC254-125-A';
lens.diam = [ 25.4, 25.4, 25.4 ];
lens.glass = { @nbk7, @nsf5 };
lens.curv = [ 0.0128816498226043, -0.0178825866471924, -0.00621805460301578 ];
lens.tc = [ 4.003571813499, 2.833474807849 ];
lens.conj = [ inf, 121.975878954];
lens.conjcurv = [ 0, 0];
