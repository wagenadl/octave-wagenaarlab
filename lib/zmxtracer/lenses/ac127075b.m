function lens = ac127075b
% ZMX/AC127-075-B.ZMX - AC127-075-B NEAR IR ACHROMATS: Infinite Conjugate 75

lens.fn = 'ac127075b';
lens.name = 'AC127-075-B';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0276090557702927, -0.0247770069375619, 0.0025119316754584 ];
lens.tc = [ 2.5, 1.5 ];
lens.conj = [ inf, 72.01762390853];
lens.conjcurv = [ 0, 0];
