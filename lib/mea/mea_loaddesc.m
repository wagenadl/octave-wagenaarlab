function desc = mea_loaddesc(ifn, failok)
% MEA_LOADDESC - Load MEABench ".desc" file
%   desc = MEA_LOADDESC(ifn) returns a structure with fields
%     keys: keys from the description file
%     values: values from the description file, converted to double
%     strings: raw values
%  desc = MEA_LOADDESC(ifn, 1) doesn't complain if the file doesn't exist.

desc.keys = {};
desc.strings = {};
desc.values = {};

if ~endswith(ifn, '.desc')
  ifn = [ifn '.desc'];
end
fd = fopen(ifn, 'r');
if fd<0
  if nargin>1
    if failok
      return
    end
  end
  error('Cannot read description file');
end

while 1
  txt = fgets(fd);
  if ~ischar(txt)
    break
  end
  idx = find(txt==':');
  if isempty(idx)
    continue;
  end
  desc.keys{end+1} = txt(1:idx(1)-1);
  txt = txt(idx(1)+1:end);
  idx = find(txt>32);
  if isempty(idx)
    txt = '';
  else
    txt = txt(idx(1):idx(end));
  end
  desc.strings{end+1} = txt;
  idx = find(txt==' ');
  if ~isempty(idx)
    txt = txt(1:idx(1)-1);
  end
  desc.values{end+1} = str2num(txt);
end

fclose(fd);
