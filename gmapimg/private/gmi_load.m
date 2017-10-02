function x = gmi_load(ifn)
% Load previously saved data
x=load(ifn);
if ~isfield(x, 'act') || ~isfield(x, 'can') || ~isfield(x, 'ifn') ...
      || ~isfield(x, 'cres') || ~isfield(x, 'arealabel') ...
	|| ~isfield(x, 'img')
  error('Cannot load data');
end
if ~isfield(x, 'deletedcan')
  x.deletedcan = logical(zeros(size(x.can.x)));
end
