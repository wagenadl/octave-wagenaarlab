function nn = nsf11(wl)
% NNSF11 - Refractive index for NSF11 glass
%   nn = NSF11(wavelength) returns the refractive index for N-SSK5 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.73759695./(1-0.013188707./x2)+0.313747346./(1-0.0623068142./x2)+1.89878101./(1-155.23629./x2));