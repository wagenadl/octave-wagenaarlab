function cc = srgbtolinearrgb(cc)
% SRGBTOLINEARRGB - Convert from (gamma corrected) sRGB to linear RGB
%    cc = SRGBTOLINEARRGB(cc) converts from sRGB to linear RGB. CC must
%    be AxBx...x3 and have values in the range [0, 1].

% The conversion here is based on http://en.wikipedia.org/wiki/SRGB

big = cc>.04045;
cc(big) = ((cc(big)+.055)/1.055).^2.4;
cc(~big) = cc(~big)/12.92;
