function nn = lafn7(wl)
% LAFN7 - Refractive index for LAFN7 glass
%   nn = LAFN7(wavelength) returns the refractive index for LAFN7 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;
nn=sqrt(1+1.66842615./(1-0.0103159999./x2)+0.298512803./(1-0.0469216348./x2)+1.0774376./(1-82.5078509./x2));