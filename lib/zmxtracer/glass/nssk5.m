function nn = nssk5(wl)
% NSSK5 - Refractive index for NSSK5 glass
%   nn = NSSK5(wavelength) returns the refractive index for N-SSK5 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.59222659./(1-0.00920284626./x2)+0.103520774./(1-0.0423530072./x2)+1.05174016./(1-106.927374./x2));
