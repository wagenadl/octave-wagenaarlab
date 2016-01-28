function cc = ciexyztolms(cc)
% CIEXYZTOLMS - Convert from CIE XYZ to  LMS

[cc, S] = unshape(cc);

M1 = rgbxyz;
M2 = rgblms;

M = inv(M1)*inv(M2);

cc = cc*M'; % That's the same as (M*cc')'

cc = reshape(cc, S);
