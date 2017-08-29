function y = lca(xx, yy, x, dx)
% LCA - Local cubic approximation
%    y = LCA(xx, yy, x, dx) fits a cubic to the data (XX, YY)
%    using a weight for each point given by
%
%      W(i) = exp[– ½ (XX(i) - X)² / DX²]
%
%    and returns the interpolated data at X.
%    See also LLA.

% Chi^2 = sum w_i (a + b x_i + c x_i^2 + d x_i^3 - y_i)^2
% Minimize w.r.t. a, b, and c:
% sum w_i (a + b x_i + c x_i^2 + d x_i^3 - y_i) = 0;
% sum w_i (a + b x_i + c x_i^2 + d x_i^3 - y_i) x_i = 0.
% sum w_i (a + b x_i + c x_i^2 + d x_i^3 - y_i) x_i^2 = 0.
% sum w_i (a + b x_i + c x_i^2 + d x_i^3 - y_i) x_i^3 = 0.
% Write X0 = sum w_i; X1 = sum w_i x_i; X2 = sum w_i x_i^2; etc;
% X0Y = sum w_i y_i; X1Y = sum w_i x_i y_i; etc.
% X0 a + X1 b + X2 c + X3 d - X0Y = 0
% X1 a + X2 b + X3 c + X4 d - X1Y = 0
% X2 a + X3 b + X4 c + X5 d - X2Y = 0
% X3 a + X4 b + X5 c + X6 d - X3Y = 0
% 
% Eliminate b from first two (we don't care about b if we shift so that x = 0):
% (X2 X0 - X1 X1) a + (X2 X2 - X1 X3) c + (X2 X3 - X1 X4) d - (X2 X0Y - X1 X1Y) = 0
% Write this as
% AA a + CC c + DD d - QQ = 0.
% Eliminate c from this and third (we don't care about c if we shift):
% (X4 AA - CC X2) a + (X4 DD - CC X5) d - (X4 QQ - CC X2Y) = 0.
% Write this as
% AAA a + DDD d - QQQ = 0.
% Eliminate d from this and fourth:
% (X6 AAA - DDD X3) a - (X6 QQQ - DDD X3Y) = 0.

if numel(x)==1
  xx = xx - x;
  w = exp(-.5 * xx.^2 / dx.^2);
  X0 = sum(w);
  X1 = sum(w.*xx);
  X2 = sum(w.*xx.^2);
  X3 = sum(w.*xx.^3);
  X4 = sum(w.*xx.^4);
  X5 = sum(w.*xx.^5);
  X6 = sum(w.*xx.^6);
  X0Y = sum(w.*yy);
  X1Y = sum(w.*yy.*xx);
  X2Y = sum(w.*yy.*xx.^2);
  X3Y = sum(w.*yy.*xx.^3);
  X4Y = sum(w.*yy.*xx.^4);
  AA = X2*X0 - X1^2;
  CC = X2^2 - X1*X3;
  DD = X2*X3 - X1*X4;
  QQ = X2*X0Y - X1*X1Y;
  AAA = X4*AA - CC*X2;
  DDD = X4*DD - CC*X5;
  QQQ = X4*QQ - CC*X2Y;
  
  y = (X6*QQQ - DDD*X3Y) ./ (X6*AAA - DDD*X3);
else
  y = 0*x;
  for n=1:numel(x)
    y(n) = lca(xx, yy, x(n), dx);
  end
end
