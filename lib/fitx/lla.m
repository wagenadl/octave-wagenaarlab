function y = lla(xx, yy, x, dx)
% LLA - Local linear approximation
%    y = LLA(xx, yy, x, dx) fits a straight line to the data (XX, YY)
%    using a weight for each point given by
%
%      W(i) = exp[– ½ (XX(i) - X)² / DX²]
%
%    and returns the interpolated data at X.
%    See also LCA.

% Chi^2 = sum w_i (a + b x_i - y_i)^2
% Minimize w.r.t. a and b:
% sum w_i (a + b x_i - y_i) = 0;
% sum w_i (a + b x_i - y_i) x_i = 0.
% Write X0 = sum w_i; X1 = sum w_i x_i; X2 = sum w_i x_i^2;
% Y1 = sum w_i y_i; XY = sum w_i x_i y_i:
% X0 a + X1 b - Y1 = 0
% X1 a + X2 b - XY = 0
% Eliminate b (we don't care about b if we shift so that x = 0):
% (X2 X0 - X1 X1) a - (X2 Y1 - X1 XY) = 0
% a = (X2 Y1 - X1 XY) / (X0 X2 - X1 X1).

if numel(x)==1
  xx = xx - x;
  w = exp(-.5 * xx.^2 / dx.^2) + eps;
  X0 = sum(w);
  X1 = sum(w.*xx);
  X2 = sum(w.*xx.^2);
  Y1 = sum(w.*yy);
  XY = sum(w.*xx.*yy);
  
  y = (X2*Y1-X1*XY) ./ (X2*X0 - X1*X1);
else
  y = 0*x;
  for n=1:numel(x)
    y(n) = lla(xx, yy, x(n), dx);
  end
end
