function s = tekload(sdir)
% TEKLOAD - Load Tektronix scope traces
%    s = TEKLOAD(sdir) loads all Tektronix scope traces in SDIR.
%    Typically, SDIR is "ALL0000" or similar.
%    Result is a structure:
%      tt (Nx1): timepoints
%      vv (NxC): voltage data
%      chs (1xC): channel IDs

s.tt=[];
s.vv=[];
s.chs=[];
s.info.dw_vsn=1;

for c=1:4
  if exist(sprintf('%s%sF%sCH%i.CSV',sdir,filesep,sdir(end-3:end),c))
    s.chs(end+1) = c;
  end
end

for k=1:length(s.chs)
  c = s.chs(k);
  fd = fopen(sprintf('%s%sF%sCH%i.CSV',sdir,filesep,sdir(end-3:end),c), 'r');
  if fd<0
    error('Cannot open data file');
  end
  tt=[];
  vv=[];
  while 1
    txt = fgets(fd);
    if ~ischar(txt)
      break;
    end
    flds = strtoks(txt, ',');
    if flds{1}(1)>='A'
      fldn = strrep(flds{1},' ','_');
      val = str2num(flds{2});
      if isempty(val)
	val=flds{2};
      end
      s.info = setfield(s.info, fldn, val);
    end
    vv=[vv; str2num(flds{end-1})];
    tt=[tt; str2num(flds{end-2})];
  end
  s.tt = tt;
  if isempty(s.vv)
    s.vv=vv;
  else
    s.vv=[s.vv vv];
  end
  fclose(fd);
end
