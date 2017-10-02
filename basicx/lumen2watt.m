function P_W = lumen2watt(lum_lm, wavelen_nm)
% LUMEN2WATT - Convert lumens to Watts at a given wavelength
%    P_W = LUMEN2WATT(lum_lm, wavelen_nm)
tab = load('lumentable.txt');
rel = interp1(tab(:,1),tab(:,2), wavelen_nm);
bas = 683;
P_W = lum_lm ./ (bas*rel);
