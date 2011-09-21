function [s, data] = dtexttext(ifn)
% DTEXTREAD - Read text files with headers
%    s = DTEXTREAD(ifn) reads text from IFN into a structure S.
%    Lines in the file are split at white space.
%    Lines starting with '#' are ignored, except at the head of the file.
%    The last '#' line before the first data line is taken to be a header.
%    The header is split as are data lines, and fields are used to name
%    the fields of the data.
%    [s, data] = DTEXTREAD(ifn) also returns the raw contents of the data
%    lines as a cell array of cell arrays.

ifd = fopen(ifn,'rb');
isheader = 1;
columnnames = {};
data = {};
while ~feof(ifd)
  txt = fgets(ifd);
  idx = find(txt>' ');
  if ~isempty(idx)
    txt = txt(idx(1):idx(end));
  else
    txt = '';
  end
  iscomment = isempty(txt);
  if ~iscomment
    iscomment = txt(1)=='#';
  end
  if iscomment
    % Comment line
    if isheader
      idx = find(txt>'#');
      txt = txt(idx(1):idx(end));
      columnnames = strtoks(txt);
      isheader = 0;
    else
      ; % ignore in middle
    end
  else
    % Data line
    isheader = 0;
    data{end+1} = strtoks(txt);
  end
end
fclose(ifd);

Y = length(data);
X = 0;
for y=1:Y
  if length(data{y})>X
    X = length(data{y});
  end  
end
while length(columnnames)<X
  columnames{end+1} = sprintf('x%i',length(columnnames)+1);
end
numdat = zeros(Y,X)+nan;
for y=1:Y
  for x=1:length(data{y})
    numdat(y,x) = str2double(data{y}{x});
  end
end

if nargout<2
  clear data
end

s = struct(columnnames{1}, numdat(:,1));
for x=2:X
  s = setfield(s, columnnames{x}, numdat(:,x));
end


  
  