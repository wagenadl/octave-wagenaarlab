function lens = ac508180
% ZMX/AC508-180-A.ZMX - Ø50.8 mm, f=180.0 mm, Near IR Achromat, ARC: 350-700 nm

lens.fn = 'ac508180';
lens.name = 'AC508-180-A';
lens.diam = [ 45.72, 50.8, 50.8, 50.8 ];
lens.glass = { @(x) (1), @nbk7, @sf5 };
lens.curv = [ 0, 0.00911244760342628, -0.012386968908708, -0.00419216902825522 ];
lens.tc = [ 5, 12, 2 ];
lens.conj = [ inf, 172.6035];
lens.conjcurv = [ 0, 0];
