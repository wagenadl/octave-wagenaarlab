function nn = nbk7(wl)
% NBK7 - Refractive index for N-BK7 glass
%   nn = NBK7(wavelength) returns the refractive index for N-BK7 glass at
%   that wavelength (specified in nm).
%
% Numbers from http://refractiveindex.info/
% Esp. http://refractiveindex.info/tmp/glass/schott/N-BK7.html

x2 = (1e-3*wl).^2;

nn=sqrt(1+1.03961212./(1-0.00600069867./x2)+0.231792344./(1-0.0200179144./x2)+1.01046945./(1-103.560653./x2));