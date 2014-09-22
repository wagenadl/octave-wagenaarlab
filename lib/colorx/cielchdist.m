function DE = cielchdist(lch1, lch2, l, c)
% CIELCHDIST - Perceptual distance between a pair of CIE L*C*h colors
%    e = CIELCHDIST(lch1, lch2), where LCH1 and LCH2 are CIE L*C*h color
%    triplets calculates the perceptual distance between them according 
%    to CMC l:c
%    See http://en.wikipedia.org/wiki/Color_difference.
 
if nargin<3
  l = 1;
end
if nargin<4
  c = 1;
end

if lch1(1)<16
  SL = .511;
else
  SL = .040975*lch1(1) / (1+.01765*lch1(1));
end

SC = 0.0638*lch1(2) / (1+.0131*lch1(2)) + .638;
F = sqrt(lch1(2)^4 / (lch1(2)^4+1900));
if mod(lch1(3),2*pi)<=345*pi/180
  T = .56 + abs(.2*cos(lch1(3)+pi*168/180));
else
  T = .36 + abs(.4*cos(lch1(3)+pi*35/180));
end
SH = SC*(F*T+1-F);

a1 = lch1(2)*cos(lch1(3));
a2 = lch2(2)*cos(lch2(3));
b1 = lch1(2)*sin(lch1(3));
b2 = lch2(2)*sin(lch2(3));
DH = sqrt((a1-a2)^2 + (b1-b2)^2 + (lch1(2)-lch2(2))^2);

DE = sqrt( ((lch2(1)-lch1(1))/(l*SL))^2 ...
    + ((lch2(2)-lch1(2))/(c*SC))^2 ...
    + (DH/SH)^2);