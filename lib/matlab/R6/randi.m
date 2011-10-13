function yy = randi(rng, varargin)
% RANDI - Simplified version of modern Matlab's "RANDI".
%    yy = RANDI(n) returns a random integer in [1, ..., N].
%    yy = RANDI(n, a, b, ...)  or RANDI(n, [a b ...] returns an AxBx... 
%    array of such numbers.

if nargin==1
  yy = 1+floor(rand(1,1)*rng);
  if yy>rng
    yy=rng;
  end
else
  S=[];
  for k=1:length(varargin)
    S=[S varargin{k}(:)'];
  end
  yy = 1+floor(rand(S)*rng);
  yy(yy>rng)=rng;
end
