function clr=clearcolor(clr)
% CLEARCOLOR  Find a color that would stand out clearly on another color
%   CLEARCOLOR(clr) returns [0,0,0] if CLR is a light color, [1,1,1] otherwise.
%   Here, 'light', means 2*red + 3*green + 1*blue >= 2.9.

if clr(1)*2+clr(2)*3+clr(3)*1 >= 2.9
  clr=[0 0 0];
else
  clr=[1 1 1];
end
