function te_setstring(h,str)
% TE_SETSTRING  Set new text of an edit widget
%    TE_SETSTRING(h,str) sets the text of an edit widget to STR.
str = replace(str,'\','{{\\}}');
str = replace(str,'_','{{\_}}');
str = replace(str,'^','{{\^}}');

caret = getappdata(h,'caret');
t = findobj(h,'tag','te_string');
str0 = get(t,'string');
idx = strfind(str0,caret);
if ~isempty(idx)
  str = [str caret];
end  
set(t,'string',str);
