function lens = lf4370
% ZMX/LF4370.ZMX - Negative Meniscus - UV Fused Silica

lens.fn = 'lf4370';
lens.name = 'LF4370';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @f_silica };
lens.curv = [ 0.0066666666666667, 0.0212947189097104 ];
lens.tc = [ 3 ];
lens.conj = [ inf, -143.1022734049];
lens.conjcurv = [ 0, 0];
