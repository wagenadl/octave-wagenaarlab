function [json, err] = djsonencode(str, ind)
% DJSONENCODE - Encode a Matlab object into JSON
%   json = DJSONENCODE(str) encodes the Matlab object STR into JSON.
%   The following basic object types can be encoded:
%      - scalar real and integer numbers
%      - scalar booleans (logicals)
%      - strings of text (one-dimensional char arrays)
%      - vectors (one-dimensional matrices) of real or integer numbers
%   In addition, one-dimensional cell arrays as well as scalar structures
%   can be encoded, provided they only contain encodable basic types or
%   nested cell arrays or structures obeying this rule.
%   That leaves many Matlab types that cannot be encoded. See MAT2JSON
%   for a possible solution.
%   If STR is not encodable, an error is reported.
%   [json, err] = DJSONENCODE(str) returns any error rather than throwing
%   it. On success, err will be empty.
%   Note that in general DJSONENCODE(JSONDECODE(json)) is not identical
%   to JSON, and JSONDECODE(JSONENCODE(str)) is not identical to STR,
%   but differences should be minimal (at least if STR is encodable).

json = '';
err = [];

if nargin<2
  ind = '';
end

if iscell(str)
  [json, err] = jsonencode_cell(str, ind);
elseif isstruct(str)
  [json, err] = jsonencode_struct(str, ind);
elseif ischar(str)
  [json, err] = jsonencode_char(str, ind);
elseif isnumeric(str) || islogical(str)
  [json, err] = jsonencode_numeric(str, ind);
elseif isempty(str)
  json = 'null';
else
  whos str
  err = 'Not encodable';
end

if nargout<2
  if isempty(err)
    clear err
  else
    error(err);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [json, err] = jsonencode_cell(str, ind)

json = '';
err = [];

if numel(str) ~= length(str)
  err = 'Can only encode 1xN cell arrays';
end

if ~isempty(err)
  return;
end

if isempty(str)
  json = '[]';
else
  ind1 = [ind '  '];
  json = sprintf('[\n%s', ind1);
  sep = '';
  sep1 = sprintf(',\n%s', ind1);
  for n = 1:length(str)
    [js1, err] = djsonencode(str{n}, ind1);
    if ~isempty(err)
      return;
    end
    json = [ json sep js1 ];
    sep = sep1;
  end
  json = [ json sprintf('\n%s]', ind) ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [json, err] = jsonencode_struct(str, ind)

json = '';
err = [];

if numel(str) ~= 1
  err = 'Can only encode scalar structures';
end

if ~isempty(err)
  return;
end

fld = fieldnames(str);
if isempty(fld)
  json = '{}';
else
  ind1 = [ind '  '];
  json = sprintf('{\n%s', ind1);
  sep = '';
  sep1 = sprintf(',\n%s', ind1);
  for f = 1:length(fld)
    [js1, err] = djsonencode(str.(fld{f}), ind1);
    if ~isempty(err)
      return;
    end
    json = [ json sep '"' fld{f} '": ' js1 ];
    sep = sep1;
  end
  json = [ json sprintf('\n%s}', ind) ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [json, err] = jsonencode_char(str, ind)

json = '';
err = [];

if numel(str) ~= size(str, 2)
  err = 'Can only encode simple strings';
end

if ~isempty(err)
  return;
end

str = strrep(str, sprintf('\n'), '\n');
str = strrep(str, sprintf('\t'), '\t');
str = strrep(str, sprintf('\r'), '\r');

json = [ '"' str '"'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [json, err] = jsonencode_numeric(str, ind)
json = '';
err = [];

if isscalar(str)
  if islogical(str)
    if str
      json = 'true';
    else
      json = 'false';
    end
  elseif ~isreal(str)
    json = '';
    err = 'Cannot encode complex numbers';
  else
    json = sprintf('%g', str);
  end
else
  if numel(str) ~= length(str)
    err = 'Can only encode vectors';
    return;
  end

  if isempty(str)
    json = '[]';
  else
    ind1 = [ind '  '];
    N = length(str);
    if N<inf
      json = '[ ';
      sep1 = ', ';
      end1 = ' ]';
    else
      json = sprintf('[\n%s', ind1);
      sep1 = sprintf(',\n%s', ind1);
      end1 = sprintf('\n%s]', ind);
    end
    sep = '';
    for n = 1:length(str)
      [js1, err] = djsonencode(str(n), ind1);
      if ~isempty(err)
        return;
      end
      json = [ json sep js1 ];
      sep = sep1;
    end
    json = [ json end1 ];
  end
end
