function ecw(str)
% ECW(func) finds the function FUNC and opens it in emacs.
fn = which(str);
if isempty(fn)
  fprintf(1,'"%s" not found.\n',str);
else
  fprintf(1,'Opening "%s".\n',fn);
end
if exist('fflush')
  fflush(1);
end

if ~isempty(fn)
  ec(fn);
end
