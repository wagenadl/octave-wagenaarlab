function x = repmatto(x, S)
% REPMATTO - Replicate and tile an array to a given size
%   y = REPMATTO(x, s), where S is a size vector, replicates the array X to
%   give it the size S. Each component of S must be an integer multiple of 
%   the current size of X in that dimension.

D = size(S);
S0 = size(x);
D0 = length(S0);

if D0<D
  S0 = [S0 ones(1, D-D0)];
  D0 = D;
elseif D<D0
  S = [S ones(1, D0-D)];
  D = D0;
end

M = S./S0;
if any(M<1)
  error('REPMATO cannot shrink');
end
if any(M~=round(M))
  error('REPMATTO can only replicate by integer factors');
end

x = repmat(x, M);

  