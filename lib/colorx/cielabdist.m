function DE = cielabdist(lab1, lab2)
% CIELABDIST - Perceptual distance between a pair of CIE L*a*b* colors
%    e = CIELABDIST(lab1, lab2) where LAB1 and LAB2 are CIE L*a*b* color 
%    triplets calculates the perceptual distance between them according 
%    to CIEDE2000.
%    See http://en.wikipedia.org/wiki/Color_difference.

kL = 1;
K1 = 0.045;
L2 = 0.015;
kC = 1;
kH = 1;

DLp = lab2(1) - lab1(1);
Lbar = (lab1(1) + lab2(1))/2;

C1 = sqrt(lab1(2)^2 + lab1(3)^2);
C2 = sqrt(lab2(2)^2 + lab2(3)^2);
Cbar = (C1+C2)/2;

ap1 = lab1(2) + (lab1(2)/2)*(1-sqrt(Cbar^7/(Cbar^7+25^7)));
ap2 = lab2(2) + (lab2(2)/2)*(1-sqrt(Cbar^7/(Cbar^7+25^7)));

Cp1 = sqrt(ap1^2 + lab1(3)^2);
Cp2 = sqrt(ap2^2 + lab2(3)^2);
Cbarp = (Cp1 + Cp2)/2;
DCp = Cp2 - Cp1;

hp1 = mod(atan2(lab1(3), ap1), 2*pi);
hp2 = mod(atan2(lab2(3), ap2), 2*pi);

if Cp1==0 || Cp2==0
  Dhp = 0;
elseif abs(hp1 - hp2) <= pi
  Dhp = hp2 - hp1;
elseif hp2 <= hp1
  Dhp = hp2 - hp1 + 2*pi;
else
  Dhp = hp2 - hp1 - 2*pi;
end

DHp = 2*sqrt(Cp1*Cp2)*sin(Dhp/2);
if Cp1==0 || Cp2==0
  Hbarp = hp1 + hp2;
elseif abs(hp1-hp2)>pi
  Hbarp = (hp1 + hp2 + 2*pi)/2;
else
  Hbarp = (hp1 + hp2)/2;
end

T = 1 - .17*cos(Hbarp-pi/6) + .24*cos(2*Hbarp) ...
    + .32*cos(3*Hbarp + pi*6/180) -.20*cos(4*Hbarp - pi*63/180);
SL = 1 + (.015*(Lbar-50)^2) / sqrt(20+(Lbar-50)^2);
SC = 1 + .045*Cbarp;
SH = 1 + .015*Cbarp*T;
RT = -2*sqrt(Cbarp^7/(Cbarp^7+25^7)) ...
    * sin(pi/3*exp(-((Hbarp-pi*275/180)/(pi*25/180))^2));

DE = sqrt((DLp/(kL*SL))^2 + (DCp/(kC*SC))^2 + (DHp/(kH*SH))^2 + ...
    RT * DCp/(kC*SC) * DHp/(kH*SH));
