function str = json2mat(json)
% JSON2MAT - Like DJSONDECODE but with some niceties for Matlab
%    str = JSON2MAT(json) decodes the JSON-encoded string JSON,
%    just like DJSONDECODE, but does some postprocessing:
%    - Any array that contains only numbers is converted to a matrix.
%    - If such an array is accompanied by a field with the same name
%      with "_size" appended to it, the matrix is reshaped to the
%      given size.
%    - Cell matrices are also suitably reshaped if there is a "_size"
%      field.

str = djsondecode(json);

str = json2mat_convert(str);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function str = json2mat_convert(str)
if isstruct(str)
  fld = fieldnames(str);
  F = length(fld);
  for f=1:F
    str.(fld{f}) = json2mat_convert(str.(fld{f}));
  end
  for f=1:F
    fs = [fld{f} '_size'];
    if ~endswith(fld{f}, '_size') && isfield(str, fs) ...
      && isnumeric(str.(fs)) ...
      && (iscell(str.([fld{f}])) || isnumeric(str.(fld{f})))
      str.(fld{f}) = reshape(str.(fld{f}), str.(fs));
      str = rmfield(str, fs);
    end
  end
elseif iscell(str)
  if all(cellfun(@(x) ((isnumeric(x) | islogical(x)) & isscalar(x)), str))
    str = cellfun(@(x) (x), str);
  else
    N = numel(str);
    for n=1:N
      str{n} = json2mat_convert(str{n});
    end
  end
end

