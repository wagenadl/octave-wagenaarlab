function str = djsondecode(json)
% DJSONDECODE - Decode a JSON-encoded string
%    str = DJSONDECODE(json) decodes the JSON-encoded string given.
%
%    If JSON represents an object (data enclosed in braces (“{…}”)),
%    the result is a struct.
%    If JSON represents an array (data enclosed in brackets (“[…]”)),
%    the result is a cell vector. (This is true even if all elements of 
%    the array are numbers, but see JSON2MAT.)
%    If JSON represents a string or a number, the result is that
%    string or number.
%    If JSON is “true” or “false,” the result is a logical scalar.
%    If JSON is “null,” the result is an empty vector.
%    If JSON cannot be parsed, an error is reported.
%
%    For details on the JSON format, visit http://www.json.org.

[str, pos] = jsondec_any(json, 1);

if pos<=length(json)
  error(sprintf('Trailing garbage at %i', pos));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str, pos] = jsondec_any(json, pos)

len = length(json);
pos = jsondec_skipwhite(json, pos);

if pos>len
  error(sprintf('Expected value at %i', pos));
end

switch json(pos)
case '{'
  [str, pos] = jsondec_parseobject(json, pos+1);
case '['
  [str, pos] = jsondec_parsearray(json, pos+1);
case '"'    
  [str, pos] = jsondec_parsestring(json, pos+1);
case '-'  
  [str, pos] = jsondec_parsenumber(json, pos+1);
  str = -str;
case { 't', 'f', 'n' }
  [str, pos] = jsondec_parsetfn(json, pos);
case '0'
  [str, pos] = jsondec_parsenumber(json, pos, 1);
case { '1', '2', '3', '4', '5', '6', '7', '8', '9' }
  [str, pos] = jsondec_parsenumber(json, pos);
otherwise
  error(sprintf('Expected value at %i', pos))
end

pos = jsondec_skipwhite(json, pos);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pos = jsondec_skipwhite(json, pos)
len = length(json);
while pos<=len && any(sprintf(' \n\t') == json(pos))
  pos = pos + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str, pos] = jsondec_parsetfn(json, pos)
len = length(json);
switch json(pos)
  case 't'
    if len-pos<3 || any(json(pos:pos+3) ~= 'true')
      error(sprintf('Expected “true” at %i', pos));
    end
    pos = pos + 4;
    str = logical(1);
  case 'f'
    if len-pos<4 || any(json(pos:pos+4) ~= 'false')
      error(sprintf('Expected “false” at %i', pos));
    end
    pos = pos + 5;
    str = logical(0);
  case 'n'
    if len-pos<3 || any(json(pos:pos+3) ~= 'null')
      error(sprintf('Expected “null” at %i', pos));
    end
    pos = pos + 4;
    str = [];
  otherwise
    error(sprintf('Garbage at %i', pos));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [num, pos] = jsondec_parsenumber(json, pos, startzero)
if nargin<3
  startzero = 0;
end
num = json(pos) - '0';
pos = pos + 1;
len = length(json);
if ~startzero
  while pos<=len && json(pos)>='0' && json(pos)<='9'
    num = num * 10 + (json(pos) - '0');
    pos = pos + 1;
  end
end
if pos<=len && json(pos)=='.'
  mul = 0.1;
  pos = pos + 1;
  while pos<=len && json(pos)>='0' && json(pos)<='9'
    num = num + mul * (json(pos) - '0');
    mul = mul/10;
    pos = pos + 1;
  end
  if mul==0.1
    error(sprintf('Expected digits after period at %i', pos));
  end
end
if pos<=len && any('eE' == json(pos))
  pos = pos + 1;
  if pos>len
    error(sprintf('Expected digits after "e" at %i', pos));
  end
  if json(pos)=='-'
    sgn = -1;
    pos = pos + 1;
  elseif json(pos)=='-'
    sgn = 1;
    pos = pos + 1;
  else
    sgn = 1;
  end
  if pos>len || json(pos)<'0' || json(pos)>'9'
    error(sprintf('Expected digits after "e" at %i', pos));
  end
  ee = 0;
  while pos<=len && json(pos)>='0' && json(pos)<='9'
    ee = ee * 10 + (json(pos) - '0');
    pos = pos + 1;
  end
  num = num * 10^(sgn*ee);
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str, pos] = jsondec_parsestring(json, pos)

len = length(json);
str = '';
while pos<=len && json(pos)~='"'
  if json(pos)<32
    error(sprintf('Unexpected control character at %i', pos));
  elseif json(pos) == '\\'
    pos = pos + 1;
    if pos>len
      error(sprintf('Unexpected end of string after backslash at %i', pos));
    end
    pos = pos + 1;
    switch json(pos-1)
      case '"'
	str(end+1) = '"';
      case '\'
	str(end+1) = sprintf('\\');
      case '/'
	str(end+1) = '/';
      case 'b'
	str(end+1) = sprintf('\b');
      case 'f'
	str(end+1) = sprintf('\f');
      case 'n'
	str(end+1) = sprintf('\n');
      case 'r'
	str(end+1) = sprintf('\r');
      case 't'
	str(end+1) = sprintf('\t');
      case 'u'
	chr = jsondec_gethexchar(json, pos);
	pos = pos + 4;
	str = [str sprintf('%c', chr)];
      otherwise
	error(sprintf('Garbage after backslash at %i', pos));
    end
  else
    str(end+1) = json(pos);
    pos = pos + 1;
  end
end
if pos>len || json(pos)~='"'
  error(sprintf('Expected end-of-string marker at %i', pos));
end
pos = pos + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function num = jsondec_gethexchar(json, pos)
len = length(json)
if len-pos<3
  error(sprintf('Expected four hex digits after \\u at %i', pos));
end
sub = json(pos:pos+3);
num = 0;
for k=1:4
  num = num*16;
  if sub(k)>='0' && sub(k)<='9'
    num = num + sub(k) - '0';
  elseif sub(k)>='A' && sub(k)<='F'
    num = num + sub(k) - 'A' + 10;
  elseif sub(k)>='a' && sub(k)<='f'
    num = num + sub(k) - 'a' + 10;
  else
    error(sprintf('Expected four hex digits after \\u at %i', pos));
  end	    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str, pos] = jsondec_parsearray(json, pos)
len = length(json);
str = {};
pos = jsondec_skipwhite(json, pos);
if pos<=len && json(pos)==']'
  pos = pos + 1;
  return;
end
while 1
  pos = jsondec_skipwhite(json, pos);
  [str{end+1}, pos] = jsondec_any(json, pos);
  pos = jsondec_skipwhite(json, pos);
  if pos>len
    error(sprintf('Missing array terminator at %i', pos));
  end
  if json(pos) == ']'
    pos = pos + 1;
    return
  elseif json(pos)==','
    pos = pos + 1;
    continue
  else
    error(sprintf('Expected “,” or “]” at %i', pos));
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str, pos] = jsondec_parseobject(json, pos)
len = length(json);
str = struct;
if pos<=len && json(pos)=='}'
  pos = pos + 1;
  return;
end
while 1
  pos = jsondec_skipwhite(json, pos);
  if pos>len || json(pos) ~= '"'
    error(sprintf('Expected string at %i', pos));
  end
  [key, pos] = jsondec_parsestring(json, pos+1);
  pos = jsondec_skipwhite(json, pos);
  if pos>len || json(pos) ~= ':'
    error(sprintf('Expected colon at %i', pos));
  end
  pos = jsondec_skipwhite(json, pos+1);
  [val, pos] = jsondec_any(json, pos);
  pos = jsondec_skipwhite(json, pos);
  if pos>len
    error(sprintf('Missing object terminator at %i', pos));
  end

  if isempty(key)
    key = '_';
  end
  if (key(1)>='a' && key(1)<='z') || (key(1)>='A' && key(1)<='Z') 
    ;
  else
    key(1) = '_';
  end
  for n=2:length(key)
    if (key(n)>='a' && key(n)<='z') || (key(n)>='A' && key(n)<='Z') ...
	  || (key(n)>='0' && key(n)<='9')
      ;
    else
      key(n) = '_';
    end
  end
  str.(key) = val;

  if json(pos) == '}'
    pos = pos + 1;
    return
  elseif json(pos) ~= ','
    error(sprintf('Expected “,” or “}” at %i', pos));
  end
  pos = pos + 1;
end
