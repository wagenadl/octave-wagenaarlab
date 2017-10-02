function y=loaddblctxt(fn)
% y=LOADDBLCTXT(fn) loads spikes from given filename into structure y
% with members
%   time    (1xN) (in seconds)
%   channel (1xN) (hw)
%   height  (1xN) (in uV)
%   width   (1xN) (in samples)
%   context (75xN) (raw)
%   postflt (75xN) (raw)

fid = fopen(fn,'rb');
if (fid<0)
  error('Cannot open the specified file');
end
raw = fread(fid,[158 inf],'int16');
fclose(fid);
ti0 = raw(1,:); idx = ti0<0; ti0(idx) = ti0(idx)+65536;
ti1 = raw(2,:); idx = ti1<0; ti1(idx) = ti1(idx)+65536;
ti2 = raw(3,:); idx = ti2<0; ti2(idx) = ti2(idx)+65536;
ti3 = raw(4,:); idx = ti3<0; ti3(idx) = ti3(idx)+65536;
y.time = (ti0 + 65536*(ti1 + 65536*(ti2 + 65536*ti3)))/25000;
y.channel = raw(5,:);
y.height = raw(6,:) .* (341/2048);
y.width = raw(7,:) / 25;
y.context = raw(8:82,:);
y.postflt = raw(83:157,:);
