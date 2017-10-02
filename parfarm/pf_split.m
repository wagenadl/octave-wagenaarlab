function cel = pf_split(ar, dim)
% PF_SPLIT - Split an ordinary array into cells for PARFARM
%   cel = PF_SPLIT(ar) splits the numeric array AR into cells for PARFARM,
%   slicing along the last dimension.
%   cel = PF_SPLIT(ar, dim) slices along the given dimension DIM.
%   Example: If AR has dimensions AxBxCxD, and DIM is 3, 
%   then CEL will be Cx1 cell vector containing AxBx1xD arrays.
%   If DIM is 4 (or not given), CEL will be a Dx1 cell vector containing
%   AxBxC arrays. (Note that Octave implicitly drops trailing singleton
%   dimensions.)

S = size(ar);
if nargin<2
  dim = length(S);
end

N = S(dim);

ar = reshape(ar, [prod(S(1:dim-1)), N, prod(S(dim+1:end))]);

if sq
  S1 = [S(1:dim-1), S(dim+1:end)];
else
  S1 = [S(1:dim-1), 1, S(dim+1:end)];
end

cel = cell(N, 1);

for n=1:N
  cel{n} = reshape(ar(:,n,:), S1);
end
