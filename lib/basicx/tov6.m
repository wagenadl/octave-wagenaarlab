function tov6(fns,dstdir)
% TOV6  Convert multiple files to Matlab V.6 format.
%   TOV6(fns,dstdir) loads all files named in FNS, and saves them as V6
%   files in DSTDIR. Intermediate directories are created as needed.
%   If FNS contains directories, they will be recursively processed.
%   FNS may be a cell array of file names, or it may be a single string.
%   If it is a single string, GLOB is applied.

if ischar(fns)
  fns=glob(fns);
end
F=length(fns);
for f=1:F
  printf('Working on file %i/%i: %s\n',f,F,fns{f});
  [dn,fn] = splitname(fns{f});
  if ~exist(sprintf('%s/%s',dstdir,dn),'dir')
    unix(sprintf('mkdir -p %s/%s',dstdir,dn));
  end
  if exist(fns{f},'dir')
    dd=dir(fns{f});
    fn_={};
    for n=1:length(dd)
      if (length(dd(n).name)>4 & strcmp(dd(n).name(end-3:end),'.mat')) | ...
	(exist([fns{f} filesep dd(n).name],'dir') & dd(n).name(1)~='.')
	fn_{end+1} = [fns{f} filesep dd(n).name];
      end
    end
    tov6(fn_,dstdir);
  else
    s = stat(fns{f});
    if s.size==0
      unix(sprintf('cp %s %s/%s',fns{f},dstdir,fns{f}));
    else
      str = load(fns{f},'-mat');
      save(sprintf('%s/%s',dstdir,fns{f}),'-struct','str','-v6','-mat');
    end
  end
end

