function nn = b270(wl)
% NB270 - Refractive index for B270 glass
%   nn = B270(wavelength) returns the refractive index for N-SSK5 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

xx = [ 0.43583	1.5341
0.47999	1.5297
0.48613	1.5292
0.54607	1.5251
0.58756	1.5230
0.58929	1.5229
0.64385	1.5207
0.65627	1.5203 ];
nn = interp1(xx(:,1), xx(:,2), wl/1e3, 'linear');
