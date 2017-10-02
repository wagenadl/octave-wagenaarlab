function cc = cielabtocielch(cc)
% CIELABTOCIELCH - Convert from CIE L*a*b* to CIE L*C*h colors
%    cc = CIELABTOCIELCH(cc) converts from CIE L*a*b* to CIE L*C*h colors
%    space. CC must be AxBx...x3.
%    In our representation, h ranges from 0 to 2 π.
%    May also be used to convert from CIE L*u*v* to CIE L* C*_uv h_uv colors.

[cc, S] = unshape(cc);

c = sqrt(cc(:,2).^2 + cc(:,3).^2);
h = atan2(cc(:,3), cc(:,2));

cc(:,2) = c;
cc(:,3) = h;

cc = reshape(cc, S);
