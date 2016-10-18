function lens = lf4706
% ZMX/LF4706.ZMX - Negative Meniscus - UV Fused Silica

lens.fn = 'lf4706';
lens.name = 'LF4706';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @f_silica };
lens.curv = [ 0.005, 0.0093993796409437 ];
lens.tc = [ 3.5 ];
lens.conj = [ inf, -493.9783878714];
lens.conjcurv = [ 0, 0];
