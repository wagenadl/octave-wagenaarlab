function str = pstars(p, uni)
% str = PSTARS(p) returns a number of stars depending on the p-value:
%
%   p <= .05:  *
%   p <= .01:  **
%   p <= .001: ***
%
% PSTARS(p, 1) returns unicode stars

if p<=.001
  str = '***';
elseif p<=.01
  str = '**';
elseif p<=.05
  str = '*';
else
  str = '';
end

if nargin>1 && uni
  str = strrep(str, '*', '⋆');
end
