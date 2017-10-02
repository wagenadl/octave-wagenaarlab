function v = hyperball(n, r)
% HYPERBALL - Surface area of hyperballs
%    v = HYPERBALL(n) returns the n-volume of an n-hyperball.
%    Thus HYPERBALL(2) return PI and HYPERBALL(3) returns 4/3*PI.
%    v = HYPERBALL(n, r) returns the n-volume area of an n-hyperball
%    of radius R.
%    Thus HYPERBALL(2, r) return PI*R^2, etc.

if nargin<2
  r=1;
end

v = (pi^(n/2) / gamma(n/2+1)) .* r.^n;
