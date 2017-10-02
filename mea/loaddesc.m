function d=loaddesc(fn)
% d = LOADDESC(fn) reads the description file FN or FN.desc 
% and returns a structure with values for each line read. 
% The fields are named from the label in the description file.
% All values are converted to double. Original strings are stored in
% the field LABEL_str.
% Repeated keys are stored in a cell array.

% matlab/loaddesc.m: part of meabench, an MEA recording and analysis tool
% Copyright (C) 2000-2002  Daniel Wagenaar (wagenaar@caltech.edu)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


d = struct('dummy','dummy');

fd = fopen(fn,'r');
if fd==0
  fd = fopen([fn '.desc'],'r');
end
if fd==0
  error([ 'File ' fn ' or ' fn '.desc not found']);
end

while 1
  txt = fgetl(fd);
  if ~ischar(txt)
    break
  end
  
  colon = min(find(txt==':'));
  key = convertkey(txt(1:(colon-1)));
  val = skipspace(txt((colon+1):end));
  numval = sscanf(val,'%f');
  if ischar(numval)
    numval=val;
  else 
    numval = numval';
  end
  
  d = descset(d,key,numval);
  d = descset(d,[ key '_str'],val);
  
end
fclose(fd);

d = rmfield(d,'dummy');

return


% ----------------------------------------------------------------------
function key = convertkey(key)
key = skipspace(key);
spc = find(key == ' ');
key(spc) = '_';
good = find((key>='0' & key<='9') | (key>='A' & key<='Z') | ...
    (key>='a' & key<='z') | key=='_');
key = key(good);
return

% ----------------------------------------------------------------------
function d = descset(d,key,val)
if isfield(d,key)
  % Key occurred before
  oldv = getfield(d,key);
  if iscell(oldv)
    % Already a cell array
    L = length(oldv);
    oldv{L+1} = val;
    d = setfield(d,key,oldv);
  else
    % Key occurred before, but only once, so not yet cell array
    newv = { oldv, val};
    d = setfield(d,key,newv);
  end
else
  % Key didn't occur before
  d = setfield(d,key,val);
end
return

% ----------------------------------------------------------------------
function s = skipspace(s)
ok = find(s ~= ' ');
s = s(min(ok):max(ok));
return
