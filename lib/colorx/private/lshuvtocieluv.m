function cc = lshuvtocieluv(cc)
% LSHUVTOCIELUV - Convert from L* s_uv h_uv colors to CIE L*u*v*
%    cc = LSHUVTOCIELUV(cc) converts L* s_uv h_uv colors to CIE L*u*v*.
%    CC must be AxBx...x3..
%    May also be used to convert (unofficial) L* s h colors to CIE L*a*b*.
% Equations taken from http://en.wikipedia.org/wiki/CIELUV and
% http://en.wikipedia.org/wiki/Colorfulness#Saturation

[cc, S] = unshape(cc);
cc(:,2) = cc(:,2) .* cc(:,1);
cc = reshape(cc, S);
cc = cielchtocielab(cc);

