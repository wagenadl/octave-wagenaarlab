function [h,m,s]=hhmmss(sec)
% str = HHMMSS(sec) returns a string "HH:MM:SS"
% [h,m,s] = HHMMSS(sec) returns numbers

m = div(sec,60); s = floor(mod(sec,60));
h = div(m,60); m=mod(m,60);

if nargout<=1
  h = sprintf('%i:%02i:%02i',h,m,s);
  clear m s
end
