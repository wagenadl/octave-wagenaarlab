function dimport(idir,ifn,dpath)
% DIMPORT - Import .mat files from another directory.
%    DIMPORT(idir, ifns, dpath) copies the named file(s) from the named 
%    source directory to the named destination directory. 
%    The trailing dir in IDIR is used as a prefix for output filenames.
%    IFNS can be a single file name, or it can contain wildcards as per GLOB,
%    or it can be a space-separated list of file names. 
%    DIMPORT(ifns, dpath) first extracts the source directory from IFNS
%    using SPLITNAME. This usage does not allow space-separated filenames,
%    but it does allow wild cards.
%    DIMPORT(ifns) imports into the current path.
%    Example: DIMPORT('/da1/dw/vscope/101224*/*xml','src'); 

switch nargin
  case 1
    dpath='.';
    [idir,ifn] = splitname(idir);
    ifn={ifn};
  case 2
    dpath=ifn;
    [idir,ifn] = splitname(idir);
    ifn={ifn};
  case 3
    ifn = strtoks(ifn,' ');
  otherwise
    error('Usage: DIMPORT([idir], ifns, [dpath])');
end

fns={};
for k=1:length(ifn)
  ff = glob([idir filesep ifn{k}]);
  for l=1:length(ff)
    fns{end+1}=ff{l};
  end
end

for k=1:length(fns)
  [dd,fn] = splitname(fns{k});
  [dd,prfx] = splitname(dd);
  ofn = [dpath filesep prfx '-' fn];
  fprintf(1,'Copying %s as %s...\n',fns{k},ofn);
  unix(sprintf('cp %s %s',fns{k},ofn));
end

  