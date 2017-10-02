function lm = candela2lumen(x_cd, twothetahalf_deg)
% CANDELA2LUMEN - Convert candelas to lumens for a given beam width
%    lm = CANDELA2LUMEN(X_cd, twothetahalf_deg)
%    The answer is approximate as it depends on the precise beam profile.
cdlm = 4182;
lm = x_cd * twothetahalf_deg^2 / cdlm;
