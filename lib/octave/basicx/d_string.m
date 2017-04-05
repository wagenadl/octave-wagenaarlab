function str = d_string(v, ind, maxlines)

% This really should make a neater table.
if nargin<3
  maxlines = d_MAXLINES;
end

fmt = sprintf('%%%is', ind*2);
inds = sprintf(fmt, '');
str = '';
cut = 0;
[Y X] = size(v);
for y=1:Y
  str1 = inds;
  if y>=maxlines
    str = [ str str1 "..." ];
    cut = 1;
    break;
  else
    add = d_unstring(v(y,:));
    if length(str1) + length(add) >= d_MAXLINEWIDTH-3
      str1 = [ str1 '"' add(1:d_MAXLINEWIDTH-length(str1)-3) '..."' ];
      cut = 1;
    else
      str1 = [ str1 '"' add '"' ];
    end
  end
  if y<Y
    str1 = [ str1 "\n" ];
  end
  str = [ str str1 ];
end
str = [ str "\n" ];
if cut && nargin<3
  str = [ str inds "(" d_size(v) ")\n" ];
end  

function str = d_unstring(v)
str = '';
for k=1:length(v)
  d = 0+v(k);
  if v(k)==9
    str = [ str '\t' ];
  elseif d==10
    str = [ str '\n' ];
  elseif d==13
    str = [ str '\r' ];
  elseif d==127
    str = [ str '\?' ];
  elseif d<32 %|| (d>=128 && d<160)
    str = [ str '\' sprintf('%03o', d) ];
  else
    str = [ str v(k) ];
  end
end

    