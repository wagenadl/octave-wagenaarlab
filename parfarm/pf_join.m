function ar = pf_join(cel, dim)
% PF_JOIN - Joins cell contents into arrays for after PARFARM
%   ar = PF_JOIN(cel) reverses the operation of PF_SPLIT. Thus, if CEL is
%   an Nx1 cell array containing AxBxC numeric array, the output will be
%   an AxBxCxN numeric array.
%   ar = PF_JOIN(cel, dim) specifies the dimension of the join. Thus,
%   if CEL contains AxBx1xD arrays and DIM=3, the output will be AxBxNxD.

N = length(cel);
if N==0
  ar = [];
  return
end

% Find proper dimensionality. (Some cells may be empty!)
S = [];
for n=1:N
  if ~isempty(cel{n})
    S = size(cel{n});
    break;
  end
end

% Deal with all-null results
if isempty(S)
  ar = [];
  return
end

% Find out how to merge
if nargin<2
  dim = length(S);
  if S(end)>1
    dim = dim + 1;
  end
else
  if S(dim) ~= 1
    error('Cannot join on non-singleton dimension');
  end
end

for n=1:N
  if ~isempty(cel{n}) && any(size(cel{n})~=S)
    error('Dimension mismatch');
  end
end

S(dim) = N;
S1 = [prod(S(1:dim-1)) N prod(S(dim+1:end))];
ar = zeros(S1);
S0 = [prod(S(1:dim-1)) 1 prod(S(dim+1:end))];
for n=1:N
  if isempty(cel{n})
    ar(:,n,:) = nan;
  else
    ar(:,n,:) = reshape(cel{n}, S0);
  end
end

ar = reshape(ar, S);

    