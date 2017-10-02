function y = lqa(xx, yy, x, dx)
% LQA - Local quadratic approximation
%    y = LQA(xx, yy, x, dx) fits a quadratic to the data (XX, YY)
%    using a weight for each point given by
%
%      W(i) = exp[– ½ (XX(i) - X)² / DX²]
%
%    and returns the interpolated data at X.
%
%    LQA behaves awfully when DX is so small that there are effectively
%    fewer than 4 points used in the fit. Beware.
%
%    See also LLA and LCA.

% Chi^2 = sum w_i (a + b x_i + c x_i^2 - y_i)^2
% Minimize w.r.t. a, b, and c:
% sum w_i (a + b x_i + c x_i^2 - y_i) = 0;
% sum w_i (a + b x_i + c x_i^2 - y_i) x_i = 0.
% sum w_i (a + b x_i + c x_i^2 - y_i) x_i^2 = 0.
% Write X0 = sum w_i; X1 = sum w_i x_i; X2 = sum w_i x_i^2; etc;
% X0Y = sum w_i y_i; X1Y = sum w_i x_i y_i; etc.
% X0 a + X1 b + X2 c - X0Y = 0
% X1 a + X2 b + X3 c - X1Y = 0
% X2 a + X3 b + X4 c - X2Y = 0
% 
% Eliminate b from first two (we don't care about b if we shift so that x = 0):
% (X2 X0 - X1 X1) a + (X2 X2 - X1 X3) c - (X2 X0Y - X1 X1Y) = 0
% Write this as
% AA a + CC c - QQ = 0
% Eliminate c from this and third (we don't care about c if we shift):
% (X4 AA - CC X2) a - (X4 QQ - CC X2Y) = 0.
% That is:
% a = (X4 QQ - CC X2Y) / (X4 AA - CC X2).

if numel(x)==1
  xx = xx - x;
  w = exp(-.5 * xx.^2 / dx.^2);
  X0 = sum(w);
  X1 = sum(w.*xx);
  X2 = sum(w.*xx.^2);
  X3 = sum(w.*xx.^3);
  X4 = sum(w.*xx.^4);
  X0Y = sum(w.*yy);
  X1Y = sum(w.*yy.*xx);
  X2Y = sum(w.*yy.*xx.^2);
  AA = X2*X0 - X1^2;
  CC = X2^2 - X1*X3;
  QQ = X2*X0Y - X1*X1Y;
  y = (X4*QQ - CC*X2Y) / (X4*AA - CC*X2);
else
  y = 0*x;
  for n=1:numel(x)
    y(n) = lqa(xx, yy, x(n), dx);
  end
end
