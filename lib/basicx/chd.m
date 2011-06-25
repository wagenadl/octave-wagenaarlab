function wd = chd(dir)
% CD     Change current working directory.
%    CD directory-spec sets the current directory to the one specified.
%    CD .. moves to the directory above the current one.
%    CD, by itself, prints out the current directory.
% 
%    WD = CD returns the current directory as a string.
% 
%    Use the functional form of CD, such as CD('directory-spec'),
%    when the directory specification is stored in a string.
% 
%    See also PWD.
%
% This version edited by DW to display directory name in title bar.
% It also removes the old './code' and '../code' from the path and adds
% new './code' and '../code' to it.

wd=builtin('cd');

if nargin==0
  if nargout==0
    builtin('cd');
  end
else
  builtin('cd',dir);
  if strcmp(getenv('TERM'),'xterm')
    nwd=builtin('cd');
    y=getenv('HOME');
    if strfind(nwd,y)==1
      x=['~' nwd(length(y)+1:end)];
    else
      x=nwd;
    end
    fprintf(2,'%c]0;(matlab) %s%c',27,x,7);
  end

  
  % Modify path
  if ~strcmp(nwd,wd)
    oldparent = dirname(wd);
    p=strtoks(path,':');
    if ~isempty(strmatch([oldparent '/code'],p,'exact'))
      rmpath([oldparent '/code']);
    end
    if ~isempty(strmatch([wd '/code'],p,'exact'))
      rmpath([wd '/code']);
    end

    newparent = dirname(nwd);
    p=strtoks(path,':');
    if exist([newparent '/code']) & isempty(strmatch([newparent '/code'],p,'exact'))
      addpath([newparent '/code']);
    end
    if exist([nwd '/code']) & isempty(strmatch([nwd '/code'],p,'exact'))
      addpath([nwd '/code']);
    end
  end
end

if nargout==0
  clear wd
end
