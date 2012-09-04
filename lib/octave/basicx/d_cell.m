function str = d_cell(v, ind)

% This really should make a neater table

fmt = sprintf('%%%is', ind*2);
inds = sprintf(fmt, '');

str = '';
[Y X] = size(v);
for y=1:Y
  str = [str inds];
  if y==1
    str = [str '{ '];
  else
    str = [str '  '];
  end
  for x=1:X
    if x>1
      str = [str '  '];
    end
    str = [str d_oneline(v{y,x}, 30) ];
  end
  if y==Y
    str = [ str ' }' ];
  end
  str = [str "\n"];
end

    