function nn = nbak4(wl)
% NBAK4 - Refractive index for N-BAK4 glass
%   nn = NBAK4(wavelength) returns the refractive index for N-BAK4 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.28834642./(1-0.00779980626./x2)+0.132817724./(1-0.0315631177./x2)+0.945395373./(1-105.965875./x2));