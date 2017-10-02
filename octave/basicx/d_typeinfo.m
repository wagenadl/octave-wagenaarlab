function str = d_typeinfo(v)
% D_TYPEINFO - Compact type info with size

ti = typeinfo(v);

if iscell(v)
  str = sprintf('{%s cell}', d_size(v));
elseif strcmp(ti, 'function handle')
  str = '(function)';
else
  if strcmp(ti, 'matrix') || strcmp(ti, 'scalar')
    ti = 'double';
  end
  ti = strrep(ti, ' matrix', '');
  ti = strrep(ti, 'scalar ', '');
  if prod(size(v)==1)
    str = sprintf('[%s]', ti);
  else
    str = sprintf('[%s %s]', d_size(v), ti);
  end
end

  