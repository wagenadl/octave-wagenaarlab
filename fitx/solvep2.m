function xx=solvep2(A,B,C)
% SOLVEP2  Solve second order polynomial equations
%    xx = SOLVEP2(A,B,C) returns the two solutions to the equation
%
%       A*x^2 + B*x + C = 0.

xx = [ 1/2./A.*(-B+(B.^2-4*C.*A).^(1/2));
  1/2./A*(-B-(B.^2-4*C.*A).^(1/2))];
