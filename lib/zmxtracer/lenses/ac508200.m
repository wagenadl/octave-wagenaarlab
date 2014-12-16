function lens = ac508200
% ZEMAX/THORLABS/ZMX/AC508-200-A.ZMX - AC508-200-A POSITIVE VISIBLE ACHROMATS: Infinite 200

lens.fn = 'ac508200';
lens.name = 'AC508-200-A';
lens.diam = [ 50.8, 50.8, 50.8 ];
lens.glass = { @nbk7, @sf2 };
lens.curv = [ 0.0091024940833788, -0.0107399849640211, -0.0026578073089701 ];
lens.tc = [ 8.5, 2 ];
lens.conj = [ inf, 193.5995646394];
lens.conjcurv = [ 0, 0];
