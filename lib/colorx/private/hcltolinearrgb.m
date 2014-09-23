function cc = hcltolinearrgb(cc, gamma)
% LINEARRGBTOHCL - Convert linear HCL to RGB color space
%    cc = HCLTOLINEARRGB(cc) converts HCL colors to linear RGB.
%    CC must be AxBx...x3.
%    The HCL color space was defined by Sarifuddin and Missaoui to be
%    more perceptually uniform than other color spaces
%    cc = HCLTOLINEARRGB(cc, gamma) specifies Missaoui's gamma parameter.

if nargin<2
  gamma = 10; % Well... this should be tuned
end

[cc, S] = unshape(cc);

Y0 = 100;
Q = exp( (1-(3*cc(:,2))./(4*cc(:,3))) .* (gamma/Y0) );
min_ = (4*cc(:,3) - 3*cc(:,2)) ./ (4*Q - 2);
max_ = min_ + (3*cc(:,2))./(2*Q);

H = mod(cc(:,1), 2*pi);
H(H>=pi) = H(H>=pi) - 2*pi;

R = max_;
G = max_;
B = max_;

idx = H>=0 & H<=pi/3;
t =tan(3*H(idx)/2);
B(idx) = min_(idx); 
G(idx) = (R(idx).*t + B(idx)) ./ (1+t);

idx = H>pi/3 & H<=2*pi/3;
B(idx) = min_(idx);
t = tan(3*(H(idx)-pi)/4);
R(idx) = (G(idx).*(1+t) - B(idx)) ./ t;

idx = H>2*pi/3;
R(idx) = min_(idx);
t = tan(3*(H(idx)-pi)/4);
B(idx) = G(idx).*(1+t) - R(idx).*t;

idx = H>=-pi/3 & H<0;
G(idx) = min_(idx);
t = tan(3*H(idx)/4);
B(idx) = G(idx).*(1+t) - R(idx).*t;

idx = H>=-2*pi/3 & H<-pi/3;
G(idx) = min_(idx);
t = tan(3*H(idx)/4);
R(idx) = (G(idx).*(1+t) - B(idx)) ./ t;

idx = H<-2*pi/3;
R(idx) = min_(idx);
t = tan(3*(H(idx)+pi)/2);
G(idx) = (R(idx).*t + B(idx)) ./ (1+t);

cc = reshape([R G B], S);
