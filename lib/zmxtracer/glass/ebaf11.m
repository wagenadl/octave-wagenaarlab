function nn = ebaf11(wl)
% EBAF11 - Refractive index for EBAF11 glass
%   nn = EBAF11(wavelength) returns the refractive index for E-BAF11 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(2.71954649-1.00472501E-2.*x2+2.00301385E-2./x2+4.65868302E-4.*x2.^-2-7.51633336E-6.*x2.^-3+1.77544989E-6.*x2.^-4);