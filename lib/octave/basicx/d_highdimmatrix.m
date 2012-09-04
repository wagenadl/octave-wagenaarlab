function str = d_highdimmatrix(v, ind, rest)

if nargin<3
  rest = '';
end

S = size(v);
S1 = S(3:end);
L = length(S1);
if L==0
  fmt = sprintf('%%%is', ind*2);
  inds = sprintf(fmt, '');
  str = [ inds '(:,:,1' rest "):\n" ];
  str = [ str d_matrix(v, ind+1)];
elseif L>1
  S0 = S1(1:end-1);
  vv = reshape(v, [S(1:2) prod(S0) S1(end)]);
  str='';
  for k=1:S1(end)
    v_ = reshape(vv(:,:,:,k), [S(1:2) S0]);
    str = [str d_highdimmatrix(v_, ind+1, sprintf(',%i%s', k, rest))];
    if k<S1(end) && any(S1(1:end-1)>1)
      str = [ str "\n"];
    end
  end
else
  fmt = sprintf('%%%is', ind*2);
  inds = sprintf(fmt, '');
  str = '';
  for k=1:S1(end)
    str = [ str inds sprintf('(:,:,%i',k) rest "):\n" ];
    str = [ str d_matrix(v(:,:,k), ind+1) ];
  end
end
