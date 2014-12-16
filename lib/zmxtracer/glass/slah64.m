function nn = slah64(wl)
% NSLAH64 - Refractive index for S-LAH64 glass
%   nn = SLAH64(wavelength) returns the refractive index for S-LAH64 glass at
%   that wavelength (specified in nm).
%
% Numbers from www.oharacorp.com/pdf/eslah64.pdf

xx = [
  0.36501 1.83016
  0.40466 1.81666
  0.43583 1.80888
  0.44157 1.80765
  0.47999 1.80060
  0.48613 1.79963
  0.54607 1.79196
  0.58756 1.78800
  0.58929 1.78785
  0.63280 1.78453
  0.64385 1.78379
  0.65627 1.78300
  0.70652 1.78018
  0.76819 1.77737
  0.85211 1.77433
  1.01398 1.76996
  1.12864 1.76750
  1.52958 1.76026
  1.97009 1.75220
  2.32542 1.74466
];

  
nn = interp1(xx(:,1), xx(:,2), wl/1e3, 'linear');
