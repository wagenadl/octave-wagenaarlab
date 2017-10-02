function h = textedit(str,actfn,varargin)
% TEXTEDIT  DWs text edit widget
%    h = TEXTEDIT(str,fcn) creates an edit widget. 
%    FCN will be called when the user hits Escape, Enter, or Tab. 
%    Its arguments will be (h,k), where H is the widget's handle, 
%    and K: 1=Enter 0=Escape 2=Tab.
%
%    NB: Deleting a textedit widget will not work correctly if there are
%    multiple such widgets in the current figure.

h = axes(varargin{:});
clr = get(gcf,'color');
set(h,'xlim',[0 1],'xtick',[],'xtickl',[],'xcolor',clr);
set(h,'ylim',[-1 1],'ytick',[],'ytickl',[],'ycolor',clr);
xywh = get(h,'position');
XYWH = get(get(h,'parent'),'position');
pixw = xywh(3) * XYWH(3);
t=text(2/pixw,0,str,'horizontala','left','verticala','middle','tag','te_string');
setappdata(h,'active',0);
setappdata(h,'caret','{{|}}');
setappdata(h,'throughkey',get(gcf,'keypressfcn'));
setappdata(h,'throughmouse',get(gcf,'windowbuttondownfcn'));
setappdata(h,'through_h',getappdata(gcf,'textedit_h'));
setappdata(gcf,'textedit_h',h);
setappdata(h,'actfn',actfn);
set(gcf,'keypressfcn',@te_winkey);
%set(gcf,'windowbuttondownfcn',@te_winbut);
set(h,'buttondownfcn',@te_mouse);
te_activate(h);

function te_winkey(f,x)
%printf('te_winkey.\n');
h = getappdata(gcf,'textedit_h');
if getappdata(h,'active')
  % Handle the key locally
  c = get(gcf,'currentchar');
  if isempty(c)
    return
  end
  %printf('  c=%i\n',c);
  if c==13 | c==10
    te_enter(h,1);
  elseif c==27
    te_enter(h,0);
  elseif c==8
    te_delete_bwd(h);
  elseif c==127
    te_delete_fwd(h);
  elseif c==9 | c==12
    te_enter(h,2)
  elseif c==1 | c==26
    te_goto(h,-inf)
  elseif c==5
    te_goto(h,inf)
  elseif c==28 | c==2
    te_goto(h,-1);
  elseif c==29 | c==6
    te_goto(h,+1);
  elseif c==11
    te_kill(h)
  elseif c>=32 & c<127
    te_insert(h,c)
  end
else
  % Feed the key through
  foo = getappdata(h,'throughkey');
  %printf('Feed through %g\n',h);
  if ~isempty(foo)
    setappdata(gcf,'textedit_h',getappdata(h,'through_h'));
    %try
      feval(foo,f);
    %catch
      ;
    %end
    setappdata(gcf,'textedit_h',h);
  end
end

function te_winbut(f,x)
h = getappdata(f,'textedit_h');
%printf('te_winbut (%g, %g).\n',f,h);
te_deactivate(h)
foo = getappdata(h,'throughmouse');
if ~isempty(foo)
  setappdata(gcf,'textedit_h',getappdata(h,'through_h'));
  feval(foo,f);
  setappdata(gcf,'textedit_h',h);
end

function te_mouse(h,x);
%printf('te_mouse.\n');
te_activate(h);

function te_deactivate(h)
setappdata(h,'active',0);
caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str = get(t,'string');
idx = strfind(str,caret);
if ~isempty(idx)
  str(idx:idx+length(caret)-1)='';
end
set(t,'string',str);

function te_activate(h)
setappdata(h,'active',1);
caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str = get(t,'string');
idx = strfind(str,caret);
if isempty(idx)
  str = [str caret];
  set(t,'string',str);
end
f = get(h,'parent');
tt = findobj(f,'tag','te_string');
for t=tt(:)'
  h_=get(t,'parent');
  if h_ ~= h
    te_deactivate(h_)
  end
end


function te_insert(h,c)
if any('\_^' == c)
  c = [ '{{\' c '}}'];
end
caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str = get(t,'string');
idx = strfind(str,caret);
if ~isempty(idx)
  str = [str(1:idx-1) c str(idx:end)];
  set(t,'string',str);
end

function te_delete_bwd(h)
caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str = get(t,'string');
idx = strfind(str,caret);
if ~isempty(idx)
  if idx>6 & strcmp(str(idx-[6 5 2 1]),'{{}}')
    str=[str(1:idx-7) str(idx:end)];
  else
    str = [str(1:idx-2) str(idx:end)];
  end
  set(t,'string',str);
end

function te_delete_fwd(h)
caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str = get(t,'string');
idx = strfind(str,caret);
if ~isempty(idx)
  idx = idx+length(caret);
  if idx+6<=length(str) & strcmp(str(idx+[0 1 4 5]),'{{}}')
    str = [str(1:idx-1) str(idx+6:end)];
  else
    str = [str(1:idx-1) str(idx+1:end)];
  end
  set(t,'string',str);
end

function te_kill(h)
caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str = get(t,'string');
idx = strfind(str,caret);
if ~isempty(idx)
  str = str(1:idx+length(caret)-1);
  set(t,'string',str);
end

function te_goto(h,d)
caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str = get(t,'string');
idx = strfind(str,caret);
str = [str(1:idx-1) str(idx+length(caret):end)];
while d
  if d>0 
    if idx+6<=length(str) & strcmp(str(idx+[0 1 4 5]),'{{}}')
      idx=idx+6;
    else
      idx=idx+1;
    end
  else % d<0
    if idx>6 & strcmp(str(idx-[6 5 2 1]),'{{}}')
      idx=idx-6;
    else
      idx=idx-1;
    end
  end
  
  if idx<=0
    idx=1;
    break;
  elseif idx>length(str)+1
    idx=length(str)+1;
    break;
  end
  d=d-sign(d);
end
str = [str(1:idx-1) caret str(idx:end)];
set(t,'string',str);
 
function te_enter(h,k)
actfn=getappdata(h,'actfn');
feval(actfn,h,k);
