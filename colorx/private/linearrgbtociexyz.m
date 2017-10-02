function cc = linearrgbtociexyz(cc)
% LINEARRGBTOCIEXYZ - Convert from linear RGB to CIE XYZ
%    cc = LINEARRGBTOCIEXYZ(cc) converts from linear RGB to XYZ. CC must
%    be AxBx...x3 and have values in the range [0, 1].

% The conversion here is based on http://en.wikipedia.org/wiki/SRGB

[cc, S] = unshape(cc);

M = rgbxyz;
   
cc = cc*M'; % That's the same as (M*cc')'

cc = reshape(cc, S);
