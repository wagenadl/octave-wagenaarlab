function str = d_matrix(v, ind)

% This really should make a neater table.

fmt = sprintf('%%%is', ind*2);
inds = sprintf(fmt, '');

str = '';
[Y X] = size(v);
for y=1:Y
  str = [str inds];
  if y==1
    str = [ str '[ ' ];
  else
    str = [ str '  ' ];
  end
  for x=1:X
    if x>1
      str = [ str '  ' ];
    end
    str = [str d_scalar(v(y,x)) ];
  end
  if y==Y
    str = [ str ' ]' ];
  end
  str = [str "\n"];
end

function str = d_scalar(v)
if iscomplex(v)
  sgn = '+';
  if imag(v)<0
    sgn = '-';
  end
  str = sprintf('%.5g %s %.5gi', real(v), sgn, abs(imag(v)));
else
  str = sprintf('%.5g', v);
end
