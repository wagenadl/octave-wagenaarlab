function lum_lm = watt2lumen(P_W, wavelen_nm)
% WATT2LUMEN - Convert Watts to lumens at a given wavelength
%    lum_lm = WATT2LUMEN(P_W, wavelen_nm)
tab = load('lumentable.txt');
rel = interp1(tab(:,1),tab(:,2), wavelen_nm);
bas = 683;
lum_lm = bas*rel .* P_W;
