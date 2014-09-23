function cc = linearrgbtosrgb(cc)
% LINEARRGBTOSRGB - Convert from linear RGB to (gamma corrected) sRGB
%    cc = LINEARRGBTOSRGB(cc) converts from linear RGB to sRGB. CC must
%    be AxBx...x3 and have values in the range [0, 1].

% The conversion here is based on http://en.wikipedia.org/wiki/SRGB

big = cc>.0031308;
cc(big) = 1.055*cc(big).^(1/2.4) - .055;
cc(~big) = cc(~big)*12.92;
