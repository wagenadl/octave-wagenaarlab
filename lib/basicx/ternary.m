function y = ternary(b, x1, x2)
% TERNARY - Implements the C ternary operator
%    y = TERNARY(b,x1,x2) returns b ? x1 : x2.
%    Note that this does NOT work element by element.

if b
  y=x1;
else
  y=x2;
end
