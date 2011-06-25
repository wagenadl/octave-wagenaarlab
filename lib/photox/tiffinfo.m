function ifo = tiffinfo(fn)
% TIFFINFO - Extract information from tiff files
%    ifo = TIFFINFO(fn) runs tiffinfo(1) on the file FN and returns the
%    information in a structure array (one struct for each layer in the
%    file).
%    Only selected fields are returned:
%
%      width, height: pixels
%      xreso, yreso:  pixels per inch
%      xpos,  ypos:   inch
%      pagename

[s,w]=unix(sprintf('tiffinfo %s',fn));
if s
  error('tiffinfo: failed to run tiffinfo command');
end

lns = strtoks(w,'\n');

ifo=struct('pagename','');
pgno=0;
for l=1:length(lns)
  str=lns{l};
  if strmatch('TIFF Directory',str)
    pgno=pgno+1;
  elseif strmatch('  Image Width',str)
    [wh,n]=sscanf(str,'  Image Width: %i Image Length: %i');
    ifo(pgno).width = wh(1);
    ifo(pgno).height = wh(2);
  elseif strmatch('  Resolution',str)
    [xy,n]=sscanf(str,'  Resolution: %g, %g');
    ifo(pgno).xreso = xy(1);
    ifo(pgno).yreso = xy(2);
  elseif strmatch('  Position',str)
    [xy,n]=sscanf(str,'  Position: %g, %g');
    ifo(pgno).xpos = xy(1);
    ifo(pgno).ypos = xy(2);
  elseif strmatch('  Page Number',str)
    ifo(pgno).pagename = str(16:end);
  end
end
