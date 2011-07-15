function x = make_varexpand(x, var)
% MAKE_VAREXPAND - Expands variables
% Expands user variables ($VAR and $=VAR); does not expand automatic variables.

while 1
  x
  idx = find(x(1:end-1)=='$' & ...
      (isalnum(x(2:end)) | x(2:end)=='''' | x(2:end)=='!'));
  if isempty(idx)
    break;
  end
  idx=idx(1);
  expnd = 0;
  quote = 0;
  if x(idx+1)==''''
    ids = idx+2;
    quote = 1;
  elseif x(idx+1)=='!'
    ids = idx+2;
    expnd = 1;
  else
    ids = idx+1;
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
  if expnd
    id0 = find(x(1:idx-1)<=' ');
    if isempty(id0)
      id0 = 0;
    else
      id0 = id0(end);
    end
    id1 = find(x(ids+ide:end)<=' ');
    if isempty(id1)
      id1 = length(x);
    else
      id1 = id1(1)+ids+ide-2;
    end
    z = strtoks(y);
    y = '';
    for k=1:length(z)
      y = [y ' ' x(id0+1:idx-1) z{k} x(ids+ide:id1)];
    end
    y = y(2:end);
    idx = id0+1;
    ide = id1-ids+1;
  elseif quote
    z = strtoks(y);
    y = '';
    for k=1:length(z)
      y = [y '''' z{k} ''', '];
    end
    y = y(1:end-2);
  end
  x = [ x(1:idx-1) y x(ids+ide:end) ];
end
