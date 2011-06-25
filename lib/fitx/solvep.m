function xx = solvep(p)
% SOLVEP  Solve n-th order polynomial equations
%    xx = SOLVEP(p) returns the n solutions to the polynomial equation
%
%      p(1)*x^n + p(2)*x^(n-1) + ... + p(n)*x + p(n+1) = 0.
%
%    This only works for 1<=n<=4. The solutions are exact.
%    NB: P must be a vector. Tensor arguments are not accepted.

switch length(p)-1
  case 1
    xx = solvep1(p(1),p(2));
  case 2
    xx = solvep2(p(1),p(2),p(3));
  case 3
    xx = solvep3(p(1),p(2),p(3),p(4));
  case 4
    xx = solvep4(p(1),p(2),p(3),p(4),p(5));
  otherwise
    error('SOLVEP only works for 1st through 4th order polynomial eqns');
end
