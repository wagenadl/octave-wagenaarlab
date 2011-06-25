function checkdoubles(pth,root)
% CHECKDOUBLES - Check for the existence of multiple functions with the same name
%    CHECKDOUBLES(pth) scans the given path recursively to find .m and .mex
%    files. For each of those, it checks whether a second definition of the
%    same function exists.

if pth(1) ~= filesep
  pth = [pwd filesep pth];
end
if nargin<2
  root=pth;
end

s=what(pth);
if isempty(s)
  fprintf(1,'checkdoubles: directory ''%s'' not found.\n',pth);
  return
end
for k=1:length(s.m)
  chkd_core(s.m{k}(1:end-2),pth,root);
end
for k=1:length(s.mex)
  chkd_core(s.mex{k}(1:end-4),pth,root);
end
d=dir(pth);
for k=1:length(d)
  if d(k).isdir & d(k).name(1) ~= '.' & ~strcmp(d(k).name,'private')
    checkdoubles([pth filesep d(k).name],root);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function chkd_core(foo,pth,root)
if strcmp(foo,'Contents')
  return
end
if isempty(foo) | foo(1)=='.'
  fprintf(1,'\nNB: Cannot check ''%s'' in %s\n',foo,pth);
  return
end

%fprintf(1,'Checking ''%s''...                     \r',foo);
a=which(foo,'-all');
bad=0;
if length(a)>1
  for k=1:length(a)
    d = dirname(a{k});
    if ~strcmp(d,pth) & ~strcmp(basename(d),'private') & ~strcmp(a{k},'variable')
      bad=1;
      break;
    end
  end
end
if bad
  fprintf(1,'\n%s, defined in %s, also exists in:\n',foo,pth)
  for k=1:length(a)
    d = dirname(a{k});
    if ~strcmp(d,pth) & ~strcmp(basename(d),'private') & ~strcmp(a{k},'variable')
      if strmatch(root,d)
	% Double in our scope
	u=unix(sprintf('diff -q %s%s%s.m %s > /dev/null',pth,filesep,foo,a{k}));
	if u
	  fprintf(1,'  %s\n',a{k});
	else
	  fprintf(1,'  Identical: %s\n',a{k});
	end
      else
	fprintf(1,'  %s\n',a{k});
      end
    end
  end
end

