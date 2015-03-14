function ff = rglob(pat, dir)
% RGLOB - Recursive globbing
%   ff = RGLOB(pattern) searches the current directory and its subdirectories
%   recursively for files matching PATTERN (as per GLOB).
%   ff = RGLOB(pattern, dir) starts the search in the given directory.
%   Hidden directories (those starting with ".") are not considered.

if nargin<2
  dir = '.';
end

ff = glob([dir filesep pat]);

dd = readdir(dir);
for k = 1:length(dd)
  if dd{k}(1)=='.'
    continue;
  end
  sub = [dir filesep dd{k}];
  if exist(sub, 'dir')
    ff1 = rglob(pat, sub);
    ff(end+1:end+length(ff1)) = ff1;
  end
end
