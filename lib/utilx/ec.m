function ec(str)
% EC(fn) opens the file FN in emacs.

if nargin<1
  str='';
end

unix(sprintf('ec %s',str));
