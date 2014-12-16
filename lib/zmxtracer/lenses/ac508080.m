function lens = ac508080
% ZEMAX/THORLABS/ZMX/AC508-080-A.ZMX - AC508-080-A POSITIVE VISIBLE ACHROMATS: Infinite 80

lens.fn = 'ac508080';
lens.name = 'AC508-080-A';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0182149362477231, -0.021551724137931, -0.0040453074433657 ];
lens.tc = [ 16, 2 ];
lens.conj = [ inf, 69.32529867905];
lens.conjcurv = [ 0, 0];
