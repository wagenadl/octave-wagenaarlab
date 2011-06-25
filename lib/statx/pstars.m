function str = pstars(p)
% str = PSTARS(p) returns a number of stars depending on the p-value:
%
%   p <= .05:  *
%   p <= .01:  **
%   p <= .001: ***

if p<=.001
  str = '***';
elseif p<=.01
  str = '**';
elseif p<=.05
  str = '*';
else
  str = '';
end
