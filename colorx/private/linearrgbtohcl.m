function cc = linearrgbtohcl(cc, gamma)
% LINEARRGBTOHCL - Convert linear RGB to HCL color space
%    cc = LINEARRGBTOHCL(cc) converts linear RGB colors to HCL colors.
%    CC must be AxBx...x3 and have values in the range [0, 1].
%    The HCL color space was defined by Sarifuddin and Missaoui to be
%    more perceptually uniform than other color spaces
%    cc = LINEARRGBTOCHL(cc, gamma) specifies Missaoui's gamma parameter.

if nargin<2
  gamma = 10; % Well... this should be tuned
end

[cc, S] = unshape(cc);

Y0 = 100;
minrgb = min(cc, [], 2);
maxrgb = max(cc, [], 2);
maxrgb(maxrgb==0) = 1e-99;
alpha = minrgb./maxrgb ./ Y0;

Q = exp(gamma*alpha);
L = (Q.*maxrgb + (Q-1).*minrgb) / 2;

d_RG = cc(:,1)-cc(:,2);
d_GB = cc(:,2)-cc(:,3);
d_BR = cc(:,3)-cc(:,1);
C = (Q/3) .* (abs(d_RG) + abs(d_GB) + abs(d_BR));

H0 = atan(d_GB./d_RG);

H = (2/3) * H0;

idx = d_RG>=0 & d_GB<0;
H(idx) = (4/3) * H0(idx);

idx = d_RG<0 & d_GB>=0;
H(idx) = (4/3) * H0(idx) + pi;

idx = d_RG<0 & d_GB<0;
H(idx) = (2/3) * H0(idx) - pi;

cc = reshape([H C L], S);

% See http://w3.uqo.ca/missaoui/Publications.html #60
% Sarifuddin, M. & Missaoui, R. (2005). A New Perceptually Uniform Color Space with Associated Color Similarity Measure for Content-Based Image and Video Retrieval, ACM SIGIR Workshop on Multimedia Information Retrieval, Salvador, Brazil, August 2005. 
% http://w3.uqo.ca/missaoui/Publications/TRColorSpace.zip
