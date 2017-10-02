function y = ddetrend(x,dim,varargin)
% DDETREND - Detrend long arbitrary dimension
%    y = DDETREND(x,dim) detrends the tensor X along dimension DIM.
%    y = DDETREND(x,dim,...) passes arguments on to DETREND.

S = size(x);
Spre=prod(S(1:dim-1));
S0 = S(dim);
Spost=prod(S(dim+1:end));

y = reshape(x,[Spre S0 Spost]);
y = permute(y,[2 1 3]);
y = reshape(y,[S0 Spre*Spost]);
y = detrend(y,varargin{:});
y = reshape(y,[S0 Spre Spost]);
y = permute(y,[2 1 3]);
y = reshape(y,S);
