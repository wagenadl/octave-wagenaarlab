function nn = nbaf10(wl)
% NBAF10 - Refractive index for N-BAF10 glass
%   nn = NBAF10(wavelength) returns the refractive index for N-BAF10 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.5851495./(1-0.00926681282./x2)+0.143559385./(1-0.0424489805./x2)+1.08521269./(1-105.613573./x2));