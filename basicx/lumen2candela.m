function x_cd = lumen2candela(lm, twothetahalf_deg)
% LUMEN2CANDELA - Convert lumens to candelas for a given beam width
%    cd_ = LUMEN2CANDELA(lm, twothetahalf_deg)
%    The answer is approximate as it depends on the precise beam profile.
cdlm = 4182;
x_cd = lm / (twothetahalf_deg^2 / cdlm);
