function nn = nsf5(wl)
% NSF5 - Refractive index for N-SF5 glass
%   nn = NSF5(wavelength) returns the refractive index for N-SF5 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.52481889./(1-0.011254756./x2)+0.187085527./(1-0.0588995392./x2)+1.42729015./(1-129.141675./x2));