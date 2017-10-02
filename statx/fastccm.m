function rho = fastccm(xx, yy, E, L)
% FASTCCM - Optimized calculation of CCM
%   rho = FASTCCM(xx, yy, E, L) calculates CCM(y|Mx). 
%   L specifies a maximum chunk length. If XX and YY are long enough
%   to make multiple chunks, RHO will be a vector of correlations within
%   each chunk.

N = numel(xx);

if nargin<4
  L = N;
end

if length(xx) ~= N
  error('fastccm: XX must be a vector');
end

if length(yy) ~= numel(yy)
  error('fastccm: YY must be a vector');
end

if numel(yy) ~= N
  error('fastccm: unequal vector lengths');
end

if numel(E) ~= 1 || E ~= round(E) || E<2
  error('fastccm: E must be a scalar integer no less than 2');
end

if numel(L) ~= 1
  error('fastccm: L must be a scalar');
end
if L<2*E 
  error('fastccm: L is too small');
end


if N>L
  ss = [1:L:N-L+1];
  ee = [L:L:N];
else
  ss = 1;
  ee = N;
end


xx = real(double(xx(:)));
yy = real(double(yy(:)));
E = real(double(E));

K = length(ss);
rho = zeros(K,1);
for k=1:K
  rho(k) = fastccm_core(xx(ss(k):ee(k)), yy(ss(k):ee(k)), E);
end
