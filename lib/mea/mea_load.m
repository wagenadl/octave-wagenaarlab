function [dat, aux] = mea_load(ifn, varargin)
% MEA_LOAD - Load MEABench data
%    dat = MEA_LOAD(ifn) loads MEABench raw or spike files.
%    MEA_LOAD(ifn, k, v, ...) specifies additional parameters as (key,value)
%    pairs.
%    MEA_LOAD automatically consults ".desc" files and reads through
%    "-1"-style continuation files.
%    Optional parameters are:
%      freq - sampling frequency (in kHz)
%      gain - MCS-style gain setting (0: 3.4 mV, 1: 1.2 mV, 2: 683 uV, 
%             3: 341 uV full range)
%      range: direct range spec (in uV)
%      auxrange: override aux range (normal 1200x range)
%      zero: digital value for 0 V on electrode channels
%      auxzero: digital value for 0 V on channels 60..63 (default: 2048)
%      elcs: load only selected electrode channels (hw chs, for raw data)
%      ctxt: flag to load or not load context (for spike data; default: not (0))
%      skip: number of records to skip at start of file (default: 0)
%      count: max number of records to read (default: inf)
%    Specified parameters override .desc file.
%    [dat, aux] = MEA_LOAD(ifn) returns additional information from ".desc"
%    file and the load-time parameters.

kv = getopt('freq gain range auxrange elcs ctxt=0 skip count zero auxzero=2048', varargin);

desc = mea_loaddesc(ifn, 1);

if isempty(kv.freq)
  idx = strmatch('Raw sample freq', desc.keys);
  if isempty(idx)
    kv.freq = 25;
  else
    kv.freq = desc.values{idx(1)};
  end
end

if isempty(kv.range)
  if isempty(kv.gain)
    idx = strmatch('Gain', desc.keys);    
    if isempty(idx)
      kv.range = 2048;
    else
      kv.range = desc.values{idx(1)} * 2048;
    end
  end
else
   switch kv.gain
     case 0
       kv.range = 3410;
     case 1
       kv.range = 1205;
     case 2
       kv.range = 683;
     case 3
       kv.range = 341;
     otherwise
       error('Illegal value for gain setting');
   end
end

if isempty(kv.auxrange)
  kv.auxrange = 2048;
end

if isempty(kv.zero)
  idx = strmatch('Digital zero', desc.keys);
  if isempty(idx)
    kv.zero = 0;
  else
    kv.zero = desc.values{idx(1)};
  end
end

if isempty(kv.skip)
  kv.skip=0;
end

if isempty(kv.count)
  kv.count=inf;
end

if endswith(ifn, '.raw')
  dat = mea_loadraw(ifn, kv);
elseif endswith(ifn, '.spike')
  dat = mea_loadspike(ifn, kv);
end

aux.desc = desc;
aux.kv = kv;

if nargout<2
  clear aux
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fd, fno] = mea_skip(ifn, reclen, skip)
fd = fopen(ifn, 'rb');
if fd<0
  error('Cannot open file');
end
fno = 0;
fseek(fd, reclen*skip, 'bof');
offset = ftell(fd)/reclen;
while offset<skip
  skip = skip-offset;
  fclose(fd);
  fno = fno + 1;
  fd = fopen(sprintf('%s-%i',ifn,fno), 'rb');
  if fd<0
    error('Cannot load raw continuation file');
  end    
  fseek(fd, reclen*skip, 'bof');    
  offset = ftell(fd)/reclen;  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dat = mea_loadraw(ifn, kv)
[fd, fno] = mea_skip(ifn, 128, kv.skip);

if isempty(kv.elcs)
  kv.elcs=[0:63];
end

% Load selected channels
if kv.count<inf
  dat = zeros(kv.count, length(kv.elcs));
  off = 0;
else
  dat = [];
  off = [];
end

while kv.count>0
  d0 = fread(fd, [64 min(kv.count, 32768)], 'int16')';
  if isempty(d0)
    fclose(fd);
    fno = fno + 1;
    fd = fopen(sprintf('%s-%i',ifn,fno), 'rb');
    if fd<0
      break;
    else
      continue;
    end
  end
  N = size(d0, 1);
  d0 = d0(:,kv.elcs+1);
  d0(:,kv.elcs<60) = d0(:,kv.elcs<60) - kv.zero;
  d0(:,kv.elcs<60) = d0(:,kv.elcs<60) * kv.range/2048;
  d0(:,kv.elcs>=60) = d0(:,kv.elcs>=60) - kv.auxzero;
  d0(:,kv.elcs>=60) = d0(:,kv.elcs>=60) * kv.auxrange/2048;
  if isempty(off)
    dat = [dat; d0];
  else
    dat(off+1:off+N,:) = d0;
    off = off+N;
  end
  kv.count = kv.count - N;
end
if fd>=0
  fclose(fd);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dat = mea_loadspike(ifn, kv)
if ~isempty(kv.elcs)
  error('Limiting electrodes is not supported for spike files');
end

[fd, fno] = mea_skip(ifn, 164, kv.skip);

if kv.count<inf
  dat.time = zeros(kv.count, 1);
  dat.channel = zeros(kv.count, 1);
  dat.height = zeros(kv.count, 1);
  dat.width = zeros(kv.count, 1);
  dat.thresh = zeros(kv.count, 1);
  if kv.ctxt
    dat.context = zeros(kv.count, 74);
  end
  off = 0;
else
  dat.time = [];
  dat.channel = [];
  dat.height = [];
  dat.width = [];
  dat.thresh = [];
  if kv.ctxt
    dat.context = [];
  end
  off = [];
end
while kv.count>0
  raw = fread(fd, [82 min(kv.count, 32768)], 'int16');
  if isempty(raw)
    fclose(fd);
    fno = fno + 1;
    fd = fopen(sprintf('%s-%i',ifn,fno), 'rb');
    if fd<0
      break;
    else
      continue;
    end
  end
  N = size(raw, 2);
  ti0 = raw(1,:); idx = find(ti0<0); ti0(idx) = ti0(idx)+65536;
  ti1 = raw(2,:); idx = find(ti1<0); ti1(idx) = ti1(idx)+65536;
  ti2 = raw(3,:); idx = find(ti2<0); ti2(idx) = ti2(idx)+65536;
  ti3 = raw(4,:); idx = find(ti3<0); ti3(idx) = ti3(idx)+65536;
  ti = ti0 + 65536*(ti1 + 65536*(ti2 + 65536*ti3));
  if isempty(off)
    dat.time = [dat.time; ti'];
    dat.channel = [dat.channel; raw(5,:)'];
    dat.height = [dat.height; raw(6,:)'];
    dat.width = [dat.width; raw(7,:)'];
    dat.thresh = [dat.thresh; raw(82,:)'];
    if kv.ctxt
      dat.context = [dat.context; raw(8:81,:)'];
    end
  else
    dat.time(off+1:off+N) = ti';
    dat.channel(off+1:off+N) = raw(5,:)';
    dat.height(off+1:off+N) = raw(6,:)';
    dat.width(off+1:off+N) = raw(7,:)';
    dat.thresh(off+1:off+N) = raw(82,:)';
    if kv.ctxt
      dat.context(off+1:off+N,:) = raw(8:81,:)';
    end
    off = off + N;
  end
  kv.count = kv.count - N;
end

if fd>=0
  fclose(fd);
end
    