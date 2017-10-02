function y = cellidx(x,idx,dim)
% CELLIDX - Create a cell array from selected members of another cell array
%    Y = CELLIDX(x,idx) creates a cell array with only the members of
%    the cell array X that are enumerated in IDX. IDX may also be a logical
%    array. This works along the first non-singleton dimension of X.
%    Y = CELLIDX(x,idx,dim) works along the specified dimension.
%    Currently, CELLIDX only works on 1- or 2-dimensional cell arrays.

S = size(x);
if ~iscell(x) | length(S)>2
  error('cellidx only works on 1- or 2-dimensional cell arrays');
end

if islogical(idx)
  idx=find(idx);
end

if nargin<3
  if S(1)==1
    dim=2;
  else
    dim=1;
  end
end

[N M]=size(x);
K=length(idx);
switch dim
  case 1
    y = cell(K,M);
    for k=1:K
      for m=1:M
	y{k,m} = x{idx(k),m};
      end
    end
  case 2
    y = cell(N,K);
    for n=1:N
      for k=1:K
	y{n,k} = x{n,idx(k)};
      end
    end
end

