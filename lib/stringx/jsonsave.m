function err = jsonsave(str, fn, mat)
% JSONSAVE - Save a JSON file
%   JSONSAVE(str, fn) encodes the object STR using JSONENCODE
%   and saves the result into the named file.
%   JSONSAVE(str, fn, 1) uses MAT2JSON instead of JSONENCODE.
%   err = JSONSAVE(...) returns encoding errors.

if nargin<3
  mat = 0;
end

if mat
  [json, err] = mat2json(str);
else
  [json, err] = jsonencode(str);
end

if ~isempty(err)
  if nargout<1 
    error(err);
  else
    return;
  end
end

fd = fopen(fn, 'w');
if fd<0
  error(sprintf('Could not open file %s', fn));
end
fwrite(fd, json);
fclose(fd);
