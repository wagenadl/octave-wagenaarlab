function [json, err] = mat2json(str)
% MAT2JSON - Like DJSONENCODE, but handles matrices better
%    json = MAT2JSON(str) encodes the Matlab object STR into JSON just
%    like JSONENCODE, except that matrices and cell arrays are handled
%    specially inside structures. Specifically, an additional field
%    with name ending in "_size" is constructed to preserve size information,
%    after which the matrix or cell array is reshaped to a vector.

str = mat2json_prep(str);
if nargout>=2
  [json, err] = djsonencode(str);
else
  json = djsonencode(str);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = mat2json_prep(str)
if iscell(str)
  for n=1:numel(str)
    str{n} = mat2json_prep(str{n});
  end
elseif isstruct(str)
  fld = fieldnames(str);
  for f=1:length(fld)
    ff = fld{f};
    str.(ff) = mat2json_prep(str.(ff));
    if iscell(str.(ff)) || (isnumeric(str.(ff)) && numel(str.(ff))>1)
      S = size(str.(ff));
      str.(ff) = reshape(str.(ff), [1 prod(S)]);
      str.([ff '_size']) = S;
    end
  end
end

      