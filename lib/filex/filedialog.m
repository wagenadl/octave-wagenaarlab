function fn = filedialog(varargin)
% FILEDIALOG  DWs alternative to uigetfile and uiputfile.
%    fn = FILEDIALOG returns the name of a file, or [].
%    The behavior can be modified with the following options:
%
%      'title': Dialog title
%      'mustexist': Only allow returning existing filenames
%      'warnexist': Warn if a file exists
%      'pattern': Initial filter pattern
%      'suggestion': Initial filename suggestion
%      'directory': Initial directory
%      'hidden': Whether or not to show files starting with '.'
%      'backup': Wheter or not to show files ending with '~'
%      'dirok': Whether or not it is OK to return the name of a directory

kv = getopt('title=''Save'' mustexist=0 warnexist=0 pattern=''*'' suggestion='''' directory='''' hidden=0 backup=0 dirok=0', ...
    varargin);

if isempty(kv.directory)
  kv.directory=fd_olddir(kv.pattern,kv.mustexist);
end

if ~isempty(kv.suggestion)
  dname = dirname(kv.suggestion);
  if ~strcmp(dname,'.')
    kv.directory = canonpath(dname);
  end
  kv.suggestion = basename(kv.suggestion);
end

xywh = get(0,'screensize');

wid = 500;
hei = 400;

%set(gcf,'menubar','none','numbertitle','off','resize','off'
figh = dialog('position',[(xywh(3)-wid)/2 (xywh(4)-hei)/2 wid hei],...
    'windowstyle','normal',...
    'handlevisibility','on',...
    'name',kv.title);

setappdata(figh,'mustexist',kv.mustexist);
setappdata(figh,'directory',kv.directory); % Current dir
setappdata(figh,'hidden',kv.hidden);
setappdata(figh,'backup',kv.backup);
setappdata(figh,'pattern',kv.pattern); % Default filter
setappdata(figh,'filter',kv.pattern); % Current filter
setappdata(figh,'dirok',kv.dirok);

uicontrol('style','listbox','position',[5 65 wid/2-10 hei-100],...
    'tag','dirs','callback',@fd_dirs);
uicontrol('style','listbox','position',[wid/2+5 65 wid/2-10 hei-100],...
    'tag','files','callback',@fd_files);

uicontrol('style','text','position',[5 35 wid-10 20],'tag','info',...
    'horizontala','left');

uicontrol('style','text','position',[5 hei-30 wid-105 20],...
    'tag','dir','horizontala','left');

uicontrol('style','pushbutton',...
    'position',[wid-105 hei-30 50 25],'string','Restore',...
    'callback',@fd_okfilter);
uicontrol('style','pushbutton',...
    'position',[wid-50 hei-30 45 25],'string','Clear',...
    'callback',@fd_clearfilter);

uicontrol('style','text','position',[5 5 38 20],...
    'string','File:','horizontala','left');
textedit(kv.suggestion,@fd_file,...
    'position',[45/wid 5/hei 1-150/wid 23/hei],...
    'tag','file');
uicontrol('style','pushbutton',...
    'position',[wid-100 5 40 25],'string','OK',...
    'callback',@fd_okfile);
uicontrol('style','pushbutton',...
    'position',[wid-55 5 50 25],'string','Cancel',...
    'callback',@fd_cancelfile);

fd_populate(figh);

mustrepeat = 1;
while mustrepeat

  uiwait(figh); 
  
  dn = getappdata(figh,'directory');
  fn = te_getstring(findobj(figh,'tag','file'));
  if isempty(fn)
    break
  else
    fn = simplifyfn([dn filesep fn]);
    % Automatically add extension?
    if ~kv.mustexist & ~(kv.dirok & exist(fn,'dir'))
      % Only if (we are not loading) AND (this is not a directory)
      extn = getappdata(figh,'filter'); 
      extn = strtoks(extn,' ');
      if ~isempty(extn)
	extn=strtoks(extn{1},'*'); 
	if ~isempty(extn)
	  extn=extn{end};
	  if length(fn)<=length(extn) | ~strcmp(fn(end-length(extn)+1:end),extn)
	    fn = [fn extn];
	  end
	end
      end
    end
  end

  mustrepeat=0;
  
  if kv.warnexist
    if exist(fn,'file')
      but = questdlg('That file already exists. Overwrite?',...
	  kv.title, ...
	  'Overwrite','Cancel','Overwrite');
      if strcmp(but,'Cancel')
	mustrepeat=1;
      end
    end
  end
  if kv.mustexist
    ee=exist(fn,'file');
    if ee==0 
      warndlg(sprintf('There is no file named "%s".',fn),kv.title,'modal');
      mustrepeat=1;
    elseif ee==7 & ~kv.dirok
      warndlg(sprintf('"%s" is a directory, not a file.',fn),kv.title,'modal');
      mustrepeat=1;
    end
  end
  
end     

fd_storedir(kv.pattern,kv.mustexist,dn);

close(figh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------------
function fd_populate(f,strt)
if nargin<2
  strt='';
end
hidden=getappdata(f,'hidden');
backup=getappdata(f,'backup');
dirn = getappdata(f,'directory');
flt = getappdata(f,'filter');
if isempty(find(flt==' '))
  str = [dirn filesep flt];
else
  str = [dirn filesep '(' flt ')'];
end
set(findobj(f,'tag','dir'),'string',str);
dd = dir(dirn);
N = length(dd);
dirs=cell(1,0);
files=cell(1,0);
for n=1:N
  if dd(n).name(1)=='.' & ~strcmp(dd(n).name,'..') & ~hidden
    ;
  elseif dd(n).name(end)=='~' & ~backup
    ;
  else
    if dd(n).isdir
      if strmatch(strt,dd(n).name)
	dirs{length(dirs)+1} = dd(n).name;
      end
    else
      if strmatch(strt,dd(n).name) & fd_match(dd(n).name,flt)
	files{length(files)+1} = dd(n).name;
      end
    end
  end
end
files=sort(files);
dirs=sort(dirs);
dirh = findobj(f,'tag','dirs');
set(dirh,'value',1);
set(dirh,'string',dirs);
fileh = findobj(f,'tag','files');
set(fileh,'value',1);
if isempty(files)
  files = '(no files)';
  setappdata(fileh,'empty',1);
  fd_showinfo(f,'');
else
  setappdata(fileh,'empty',0);
  fd_showinfo(f,'');%files{1});
end
set(fileh,'string',files);

%---------------------------------------------------------------------
function ok = fd_match(name,flt)
ok=0;
if isempty(flt)
  ok=1;
  return
end
flts=strtoks(flt);
for f=1:length(flts)
  if exist('regexp')
    flt = fd_mkregexp(flts{f});
    ok = ~isempty(regexp(name,flt,'once'));
    if ok
      break;
    end
  else
    flt=flts{f};
    idx=find(flt=='*');
    if ~isempty(idx)
      t0 = flt(1:idx(1)-1);
      t1 = flt(idx(end)+1:end);
      if length(name) >= length(t0)+length(t1)
	ok = strcmp(name(1:length(t0)),t0) & strcmp(name(end-length(t1)+1:end),t1);
	if ok
	  break
	end
      end
    end
  end
end

%---------------------------------------------------------------------
function rex = fd_mkregexp(flt)
rex='^';
for l=1:length(flt)
  switch flt(l)
    case '.'
      rex=[rex '\.'];
    case '*'
      rex = [rex '.*'];
    otherwise
      rex = [rex flt(l)];
  end
end
rex=[rex '$'];


%---------------------------------------------------------------------
function fd_keypress(f,x)
printf('fd_keypress\n');
whos

%---------------------------------------------------------------------
function fd_files(h,x)
if getappdata(h,'empty')
  fd_showinfo(f,'')
  return
end
f=get(h,'parent');
str=get(h,'string');
idx=get(h,'value');
fd_showinfo(f,str{idx});
newf = str{idx};
te_setstring(findobj(f,'tag','file'),newf);
if strcmp(get(gcf,'selectiontype'),'open')
  fd_okfile(h);
end

%---------------------------------------------------------------------
function fd_dirs(h,x)
f=get(h,'parent');
str=get(h,'string');
idx=get(h,'value');
if ~strcmp(get(gcf,'selectiontype'),'open')
  fd_showinfo(f,str{idx});
  if getappdata(f,'dirok')
    newf = str{idx};
    te_setstring(findobj(f,'tag','file'),newf);
  end
  return
end

try
  newd = str{idx};
  oldd = getappdata(f,'directory');
  if strcmp(newd,'..')
    idx = find(oldd==filesep);
    if ~isempty(idx)
      newd = oldd(1:idx(end)-1);
      if isempty(newd)
	newd=filesep;
      end
    end
  else
    newd = [ oldd filesep newd ];
  end
  newd = simplifyfn(newd);
  if exist(newd,'dir')
    setappdata(f,'directory',newd);
    fd_populate(f);
  end
catch
  ;
end

%---------------------------------------------------------------------
function fd_okfilter(h,x)
f=get(h,'parent');
setappdata(f,'filter',getappdata(f,'pattern'));
fd_populate(f);

%---------------------------------------------------------------------
function fd_clearfilter(h,x)
f=get(h,'parent');
setappdata(f,'filter','*');
fd_populate(f);

%---------------------------------------------------------------------
function fd_cancelfile(h,x)
f=get(h,'parent');
te_setstring(findobj(f,'tag','file'),'');
uiresume(f);

%---------------------------------------------------------------------
function fd_file(h,k)
f=get(h,'parent');
fn = te_getstring(h);
if k==1
  % Enter
  if isempty(fn)
    return
  end
  if fn(1)=='~' | fn(1)==filesep
    newf = simplifyfn(fn);
  else
    newf = simplifyfn([getappdata(f,'directory') filesep fn]);
  end
  extn = getappdata(f,'filter'); 
  if ~isempty(extn)
    extn=strtoks(extn,'*'); 
    if isempty(extn)
      extn='';
    else
      extn=extn{end};
    end
  end
  if exist(newf,'dir')
    te_setstring(h,'')
    setappdata(f,'directory',newf);
    fd_populate(f);
  elseif exist(newf,'file')==2 | exist([newf extn],'file')==2 | ...
	getappdata(f,'mustexist')==0
    uiresume(f);
  end
elseif k==2
  % Tab
  if isempty(fn)
    return
  end
  if strcmp(fn,'~')
    te_setstring(h,'')
    setappdata(f,'directory',simplifyfn('~'));
    fd_populate(f);
    return
  elseif strcmp(fn,'..')
    te_setstring(h,'')
    setappdata(f,'directory',simplifyfn([getappdata(f,'directory'), '/..']));
    fd_populate(f);
    return
  end
  
  [fn,unq] = tabcomplete(fn,getappdata(f,'directory'));
  te_setstring(h,fn);
  if unq
    full = simplifyfn([getappdata(f,'directory') filesep fn]);
    if exist(full,'dir')
      te_setstring(h,'')
      setappdata(f,'directory',full);
      fd_populate(f);
      return
    end
  end
  fd_populate(f,fn);
elseif k==0
  fd_cancelfile(h);
end

%---------------------------------------------------------------------
function fd_okfile(h,x)
f=get(h,'parent');
%printf('OKFILE: %s/%s\n',getappdata(f,'directory'),...
%    te_getstring(findobj(f,'tag','file')));
if isempty(te_getstring(findobj(f,'tag','file')))
  beep;
else
  uiresume(f);
end

%---------------------------------------------------------------------
function fd_showinfo(f,str)
dn = getappdata(f,'directory');
full=simplifyfn([dn filesep str]);
if ~isempty(str) & exist(full,'file') & exist('stat')==2
  st=stat(full);
  dt = datestr(st.mtime,1);
  hr = datestr(st.mtime,15);
  str = sprintf('%s  (%i %i)  %s  %s %s  %s',...
      fd_perms(st.mode),double(st.uid),double(st.gid),...
      nicefilesize(st.size),...
      dt,hr,str);
  set(findobj(f,'tag','info'),'string',str);
else
  set(findobj(f,'tag','info'),'string','');
end

%---------------------------------------------------------------------
function d = fd_olddir(pat,mustexist)
if ~isappdata(0,'filedialog__data')
  d=pwd;
  return
end

fddat = getappdata(0,'filedialog__data');

for k=1:length(fddat.pats)
  if strcmp(pat,fddat.pats{k}) & mustexist==fddat.mustexist(k)
    d=fddat.dirs{k};
    return
  end
end

d=pwd;


%---------------------------------------------------------------------
function fd_storedir(pat,mustexist,dn)
if isappdata(0,'filedialog__data')
  fddat = getappdata(0,'filedialog__data');
else
  fddat.pats=cell(0,1);
  fddat.mustexist=logical(zeros(0,1));
  fddat.dirs=cell(0,1);
end

for k=1:length(fddat.pats)
  if strcmp(pat,fddat.pats{k}) & mustexist==fddat.mustexist(k)
    fddat.dirs{k} = dn;
    setappdata(0,'filedialog__data',fddat);
    return
  end
end

N=length(fddat.pats);
fddat.pats{N+1} = pat;
fddat.mustexist(N+1) = mustexist;
fddat.dirs{N+1} = dn;

setappdata(0,'filedialog__data',fddat);
