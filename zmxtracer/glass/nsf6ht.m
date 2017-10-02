function nn = nsf6ht(wl)
% NSF6HT - Refractive index for N-SF6HT glass
%   nn = NSF6HT(wavelength) returns the refractive index for N-SF6HT glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.77931763./(1-0.0133714182./x2)+0.338149866./(1-0.0617533621./x2)+2.08734474./(1-174.01759./x2));