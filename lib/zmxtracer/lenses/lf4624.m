function lens = lf4624
% ZEMAX/THORLABS/ZMX/LF4624.ZMX - Negative Meniscus - UV Fused Silica

lens.fn = 'lf4624';
lens.name = 'LF4624';
lens.diam = [ 25.4, 25.4 ];
lens.glass = { @f_silica };
lens.curv = [ 0.0066666666666667, 0.0176647235470765 ];
lens.tc = [ 3.5 ];
lens.conj = [ inf, -193.2364327714];
lens.conjcurv = [ 0, 0];
