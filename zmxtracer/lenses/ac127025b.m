function lens = ac127025b
% ZMX/AC127-025-B.ZMX - AC127-025-B NEAR IR ACHROMATS: Infinite Conjugate 25

lens.fn = 'ac127025b';
lens.name = 'AC127-025-B';
lens.diam = [ 12.7, 12.7, 12.7 ];
lens.glass = { @nlak22, @nsf6ht };
lens.curv = [ 0.0618046971569839, -0.0751314800901578, -0.0145900204260286 ];
lens.tc = [ 5, 2 ];
lens.conj = [ inf, 21.04297335917];
lens.conjcurv = [ 0, 0];
