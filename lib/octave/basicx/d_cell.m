function str = d_cell(v, ind, maxlines)

% This really should make a neater table

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
  if y==1
    str1 = [str1 '{ '];
  else
    str1 = [str1 '  '];
  end
  if y>=maxlines
    str = [ str str1 "..." ];
    cut = 1;
    break;
  else
    for x=1:X
      if x>1
	str1 = [str1 '  '];
      end
      add = d_oneline(v{y,x}, 30);
      if length(str1) + length(add) >= d_MAXLINEWIDTH
	str1 = [ str1 '...' ];
	cut = 1;
	break;
      else
	str1 = [ str1 add ];
      end
    end
  end
  if y<Y
    str1 = [ str1 "\n" ];
  end
  str = [ str str1 ];
end
str = [ str " }\n" ];

if cut && nargin<3
  str = [ str inds "(" d_size(v) ")\n" ];
end  
