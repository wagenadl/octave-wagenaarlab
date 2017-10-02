function y=loadspks(fn,typ)
% y=LOADSPKSNOC(fn) loads spikes from given filename into structure y
% with members
%   time    (1xN) (in seconds)
%   channel (1xN)
%   height  (1xN)
%   width   (1xN)
% Context is trashed.
% y=LOADSPKSNOC(fn,2) assumes that the raw data was sampled at 18 kHz and
% that full range is 625 mV / 1200.
% y=LOADSPKSNOC(fn,1) assumes that the raw data was sampled at 25 kHz and
% that full range is 341 uV.

if nargin<2
  typ=0;
end

fid = fopen(fn,'rb');
if (fid<0)
  error('Cannot open the specified file');
end

fseek(fid,0,1);
N=ftell(fid)/164;
fseek(fid,0,-1);

raw = zeros(8,N);
n=0;
while 1,
  [dat, cnt] = fread(fid,[82 10000],'int16');
  cnt=cnt/82;
  if cnt 
    raw(:,[1:cnt]+n) = dat([1:7 82],:);
    n = n + cnt;
    fprintf(2,'Spikeinfos read: %i\n',n);
  else
    break
  end
end  
fclose(fid);
ti0 = raw(1,:); idx = ti0<0; ti0(idx) = ti0(idx)+65536;
ti1 = raw(2,:); idx = ti1<0; ti1(idx) = ti1(idx)+65536;
ti2 = raw(3,:); idx = ti2<0; ti2(idx) = ti2(idx)+65536;
ti3 = raw(4,:); idx = ti3<0; ti3(idx) = ti3(idx)+65536;
y.time = (ti0 + 65536*(ti1 + 65536*(ti2 + 65536*ti3)));
y.channel = raw(5,:);
y.height = raw(6,:);
y.width = raw(7,:);
y.thresh = raw(8,:);

if typ==1
  y.time = y.time ./ 25000;
  y.height = y.height .* (341/2048);
  y.width = y.width ./ 25;
  y.thresh = y.thresh .* (341/2048);
elseif typ==2;
  y.time = y.time / 18000;
  y.height = y.height .* (625/1.2/2048);
  y.width = y.width ./ 18;
  y.thresh = y.thresh .* (625/1.2/2048);
end
