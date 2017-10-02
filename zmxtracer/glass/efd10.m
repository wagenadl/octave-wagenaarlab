function nn = efd10(wl)
% EFD10 - Refractive index for EFD10 glass
%   nn = EFD10(wavelength) returns the refractive index for EFD10 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(2.8815180-1.3228312E-2.*x2+3.1455590E-2.*x2.^-1+2.6851666E-3.*x2.^-2-2.2577544E-4.*x2.^-3+2.4693268E-5.*x2.^-4);