function nn = sf2(wl)
% NSF2 - Refractive index for SF2 glass
%   nn = SF2(wavelength) returns the refractive index for SF2 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.40301821./(1-0.0105795466./x2)+0.231767504./(1-0.0493226978./x2)+0.939056586./(1-112.405955./x2));
