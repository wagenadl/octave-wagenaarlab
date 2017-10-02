function x=clip01(x)
% CLIP01  Clip real numbers to the range [0,1].
%   CLIP01(x) returns X clipped to [0,1].

x(x<0)=0;
x(x>1)=1;
