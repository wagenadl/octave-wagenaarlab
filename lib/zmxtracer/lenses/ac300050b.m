function lens = ac300050b
% ZMX/AC300-050-B.ZMX - AC300-050-B NEAR IR ACHROMATS: Infinite Conjugate 50

lens.fn = 'ac300050b';
lens.name = 'AC300-050-B';
lens.diam = [ 30, 30, 30 ];
lens.glass = { @nbaf10, @nsf6ht };
lens.curv = [ 0.0325097529258778, -0.0358937544867193, -0.0036643459142543 ];
lens.tc = [ 9.5, 2 ];
lens.conj = [ inf, 42.69864176546];
lens.conjcurv = [ 0, 0];
