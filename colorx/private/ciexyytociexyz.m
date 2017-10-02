function cc = ciexyytociexyz(cc)
% CIEXYYTOCIEXYZ - Convert from CIE xyY to CIE XYZ
%    cc = CIEXYYTOCIEXYZ() converts from CIE xyY to CIE XYZ. CC must
%    be AxBx...x3 and have values in the range [0, 1].

% The conversion here is based on 
% http://en.wikipedia.org/wiki/CIE_1931_color_space

[cc, S] = unshape(cc);

Y = cc(:,3);
cc(:,3) = Y .* (1 - cc(:,1) - cc(:,2)) ./ cc(:,2); % Z
cc(:,1) = Y .* cc(:,1) ./ cc(:,2); % X
cc(:,2) = Y;

cc = reshape(cc, S);


