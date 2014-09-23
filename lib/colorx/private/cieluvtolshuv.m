function  cc = cieluvtolshuv(cc)
% CIELUVTOLSHUV - Convert CIE L*u*v* to L* s_uv h_uv colors
%    cc = CIELUVTOLSHUV(cc) converts CIE L*u*v* to L* s_uv h_uv colors.
%    CC must be AxBx...x3..
%    May also be used to convert CIE L*a*b* to (unofficial)  L* s h colors.

% Equations taken from http://en.wikipedia.org/wiki/CIELUV and
% http://en.wikipedia.org/wiki/Colorfulness#Saturation

cc = cielabtocielsh(cc);
[cc, S] = unshape(cc);
cc(:,2) = cc(:,2) ./ cc(:,1);
cc = reshape(cc, S);