function str = e2ten(str,fmt)
% str = E2TEN(str) converts a string like '10.4e+01' to '10.4*10^{1}'.
% cells = E2TEN(cells) converts many strings
% str = E2TEN(fmt,num) converts a number, after using sprintf

if iscell(str)
  X=length(str)
  for x=1:X
    str{x} = e2ten(str{x});
  end
else
  if nargin>1
    str=sprintf(str,fmt); % note that str and fmt are mislabeled!
  end
  str=strtoks(str,'e');
  if length(str)>1
    str{2}=atoi(str{2});
    str = [str{1} '*10^{' sprintf('%i',str{2}) '}'];
  else
    str = str{1};
  end
end
