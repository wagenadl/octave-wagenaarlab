function cc= lmstociexyz(cc)
% LMSTOCIEXYZ - Convert from LMS to CIE XYZ

[cc, S] = unshape(cc);

M1 = rgbxyz;
M2 = rgblms;

M = M1*inv(M2);

cc = cc*M'; % That's the same as (M*cc')'

cc = reshape(cc, S);
