function str = jsonload(fn, mat)
% JSONLOAD - Load a JSON file
%   str = JSONLOAD(fn) loads the named file and parses it with JSONDECODE.
%   str = JSONLOAD(fn, 1) uses JSON2MAT rather than JSONDECODE.

fd = fopen(fn, 'r');
if fd<0
  error(sprintf('Could not open file %s', fn));
end
json = fread(fd, [1 inf], '*char');
fclose(fd);

if nargin>=2 && ~isempty(mat) && mat>0
  str = json2mat(json);
else
  str = jsondecode(json);
end
