function s = hypersphere(n, r)
% HYPERSPHERE - Surface area of hyperspheres
%    s = HYPERSPHERE(n) returns the n-volume of an n-hypersphere (i.e., the
%    surface area of an (n+1) ball).
%    Thus HYPERSPHERE(1) return 2*PI and HYPERSPHERE(2) returns 4*PI.
%    s = HYPERSPHERE(n, r) returns the n-volume area of an n-hypersphere
%    of radius R.
%    Thus HYPERSPHERE(1, r) return 2*PI*R, etc.

if nargin<2
  r=1;
end

s = (2*pi^((n+1)/2) / gamma((n+1)/2)) .* r.^n;
