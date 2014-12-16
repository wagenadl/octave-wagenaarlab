function nn = sf5(wl)
% NSF5 - Refractive index for SF5 glass
%   nn = SF5(wavelength) returns the refractive index for SF5 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.46141885./(1-0.0111826126./x2)+0.247713019./(1-0.0508594669./x2)+0.949995832./(1-112.041888./x2));