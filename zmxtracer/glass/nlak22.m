function nn = nlak22(wl)
% NLAK22 - Refractive index for N-LAK22 glass
%   nn = NLAK22(wavelength) returns the refractive index for N-LAK22 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.14229781/(1-0.00585778594./x2)+0.535138441/(1-0.0198546147./x2)+1.04088385/(1-100.834017./x2));