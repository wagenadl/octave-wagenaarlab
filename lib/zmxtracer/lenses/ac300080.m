function lens = ac300080
% ZMX/AC300-080-A.ZMX - AC300-080-A POSITIVE VISIBLE ACHROMATS: Infinite 80

lens.fn = 'ac300080';
lens.name = 'AC300-080-A';
lens.diam = [ 30, 30, 30 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0178635226866738, -0.0226398007697532, -0.0045495905368517 ];
lens.tc = [ 8.5, 2 ];
lens.conj = [ inf, 74.17710046233];
lens.conjcurv = [ 0, 0];
