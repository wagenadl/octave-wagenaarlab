function nn = f_silica(wl)
% F_SILICA - Refractive index for F_SILICA glass
%   nn = F_SILICA(wavelength) returns the refractive index for F_SILICA glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/
% http://refractiveindex.info/tmp/main/SiO2/Malitson.html
x = 1e-3*wl;

nn=sqrt(1+0.6961663./(1-(0.0684043./x).^2)+0.4079426./(1-(0.1162414./x).^2)+0.8974794./(1-(9.896161./x).^2));