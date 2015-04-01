function y = ternary(b, x1, x2)
% TERNARY - Implements the C ternary operator
%    y = TERNARY(b,x1,x2) returns b ? x1 : x2.

if isscalar(b)
  if b
    y=x1;
  else
    y=x2;
  end
else
  y = x2;
  y(find(b)) = x1;
end  

