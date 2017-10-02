function xyz = whitepoints(s)
% WHITEPOINTS - Return XYZ values of standard white points
%    xyz = WHITEPOINTS(s) returns XYZ values of one of several standard
%    white points: d50, d55, d65, a, c

% Source: Matlab R2012b's whitepoint function

switch s
  case 'd50'
    xyz = [0.9642    1.0000    0.8251];
  case 'd55'
    xyz = [0.9568    1.0000    0.9214];
  case 'd65'
    xyz = [0.9504    1.0000    1.0889];
  case 'a'
    xyz = [1.0985    1.0000    0.3558];
  case 'c'
    xyz = [0.9807    1.0000    1.1823];
  otherwise
    error('Unknown white point')
end
