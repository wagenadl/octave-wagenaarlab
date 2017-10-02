function [stm,wrn] = raw2stm(raw)
% stm = RAW2STM(raw) returns stimulus hw channel numbers.
% RAW must be the result of idstim, and produced by [-15*C,-15*R].
% [stm,wrn] = RAW2STM(raw) also returns a vector of warnings:
% any point more than .3 away from a centroid generates a warning.

c8 = 256.64;
c1 = 1822.47;

r8 = 256.43;
r1 = 1822.4; % Not determined directly

col = 1+(raw(:,1)-c1).*7./(c8-c1);
row = 1+(raw(:,2)-r1).*7./(r8-r1);

if nargout>1
  cm = mod(col+10,1);
  rm = mod(row+10,1);
  wrn = (cm>.3 & cm<.7) | (rm>.3 & rm<.7);
end

stm = cr2hw(floor(col+.5),floor(row+.5))';
