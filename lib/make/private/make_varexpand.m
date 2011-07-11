function x = make_varexpand(x, var)
% MAKE_VAREXPAND - Expands variables
% Expands user variables ($VAR and $=VAR); does not expand automatic variables.

idx = find(x(1:end-1)=='$' & (isalnum(x(2:end)) | x(2:end)=='='));
while ~isempty(idx)
  x(idx:end)
  idx=idx(1);
  if x(idx+1)=='='
    ids = idx+2;
    quote=1;
  else
    ids = idx+1;
    quote=0;
  end
  y=x(ids:end);
  ide=find(~isalnum(y));
  if isempty(ide)
    ide = length(y);
  else
    ide = ide(1)-1;
  end
  id = strmatch(y(1:ide), var.keys, 'exact');
  if isempty(id)
    error(sprintf('Unknown variable %s', y(1:ide)));
  end
  y = var.values{id};
  if quote
    z = strtoks(y);
    y = '';
    for k=1:length(z)
      y = [y '''' z{k} ''', '];
    end
    y = y(1:end-2);
  end
  x = [ x(1:idx-1) y x(ids+ide:end) ];
  idx = find(x(1:end-1)=='$' & (isalnum(x(2:end)) | x(2:end)=='='));
end
