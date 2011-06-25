function str = te_getstring(h)
% TE_GETSTRING  Get current text of an edit widget
%    str = TE_GETSTRING(h) returns the current text of an edit widget.

caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str = get(t,'string');
idx = strfind(str,caret);
if isempty(idx)
  ;
else
  str = [str(1:idx-1) str(idx+length(caret):end)];
end
str = replace(str,'{{\\}}','\');
str = replace(str,'{{\_}}','_');
str = replace(str,'{{\^}}','^');
