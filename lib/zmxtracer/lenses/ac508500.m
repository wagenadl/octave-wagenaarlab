function lens = ac508500
% ZEMAX/THORLABS/ZMX/AC508-500-A.ZMX - AC508-500-A POSITIVE VISIBLE ACHROMATS: Infinite 500

lens.fn = 'ac508500';
lens.name = 'AC508-500-A';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nbk7, @sf2 };
lens.curv = [ 0.0036643459142543, -0.0042685789900542, -0.0010309278350515 ];
lens.tc = [ 5, 2 ];
lens.conj = [ inf, 495.8439542766];
lens.conjcurv = [ 0, 0];
