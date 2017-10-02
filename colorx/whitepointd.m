function xyz = whitepointd(t)
% WHITEPOINTD - Return whitepoint for a given color temperature
%    xyz = WHITEPOINTD(t), where T is a color temperature in Kelvin,
%    returns the XYZ values corresponding to the white point at that
%    temperature.

% Source: https://en.wikipedia.org/wiki/Standard_illuminant#Illuminant_series_D

x = .244063 + .09911e3./t + 2.9678e6./t.^2 - 4.6070e9./t.^3;
x2 = .237040 + .24748e3./t + 1.9018e6./t.^2 - 2.0064e9./t.^3;
x(t>7000) = x2(t>7000);
y = -3.000*x.^2 + 2.870*x - 0.275;

Y = ones(size(t));
X = (Y./y) .* x;
Z = (Y./y) .* (1 - x - y);
if size(Y,2)>1
  xyz = cat(3, X, Y, Z);
else
  xyz = [X Y Z];
end
