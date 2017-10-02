function nn = sf10(wl)
% SF10 - Refractive index for SF10 glass
%   nn = SF10(wavelength) returns the refractive index for N-SF10 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.61625977./(1-0.0127534559./x2)+0.259229334./(1-0.0581983954./x2)+1.07762317./(1-116.60768./x2));