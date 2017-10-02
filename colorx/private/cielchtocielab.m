function cc = cielchtocielab(cc)
% CIELCHTOCIELAB - Convert from CIE L*C*h to CIE L*a*b* colors
%    cc = CIELCHTOCIELAB(cc) converts from CIE L*C*h to CIE L*a*b* color 
%    space. CC must be AxBx...x3.
%    In our representation, H ranges from 0 to 2 π.
%    May also be used to convert from CIE L* C*_uv h_uv to CIE L*u*v* colors.


[cc, S] = unshape(cc);

a = cc(:,2) .* cos(cc(:,3));
b = cc(:,2) .* sin(cc(:,3));

cc(:,2) = a;
cc(:,3) = b;

cc = reshape(cc, S);


