function nn = fd10(wl)
% FD10 - Refractive index for EFD10 glass
%   nn = EFD10(wavelength) returns the refractive index for EFD10 glass at
%   that wavelength (specified in nm).
%   Caution: Numbers are for E-FD10, not FD10. Hopefully
%   not too different.

nn = efd10(wl);
