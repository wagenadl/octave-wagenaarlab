function cc = ciexyztociexyy(cc)
% CIEXYZTOCIEXYY - Convert from CIE XYZ to CIE xyY
%    cc = CIEXYZTOCIEXYY(cc) converts from CIE XYZ to CIE xyY. CC must
%    be AxBx...x3 and have values in the range [0, 1].

% The conversion here is based on 
% http://en.wikipedia.org/wiki/CIE_1931_color_space

[cc, S] = unshape(cc);

c0 = sum(cc, 2);
cc(:,1) = cc(:,1)./c0; % x
cc(:,3) = cc(:,2);     % Y
cc(:,2) = cc(:,2)./c0; % y

cc = reshape(cc, S);

