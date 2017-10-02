function lens = ac127030b
% ZMX/AC127-030-B.ZMX - AC127-030-B NEAR IR ACHROMATS: Infinite Conjugate 30

lens.fn = 'ac127030b';
lens.name = 'AC127-030-B';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0504540867810293, -0.0618046971569839, -0.0126454223571067 ];
lens.tc = [ 3.5, 1.5 ];
lens.conj = [ inf, 27.30530978468];
lens.conjcurv = [ 0, 0];
