function y=readspks(fid,nmax)
% y=READSPKS(fid,nmax) reads upto NMAX spikes from given file into
% structure y with members
%   time    (1xN) (in seconds)
%   channel (1xN)
%   height  (1xN)
%   width   (1xN)
%   context (75xN)
% If there's nothing to be read, READSPKS returns an empty matrix.

raw = fread(fid,[82 nmax],'int16');
if isempty(raw)
  y=[];
  return;
end
ti0 = raw(1,:); idx = find(ti0<0); ti0(idx) = ti0(idx)+65536;
ti1 = raw(2,:); idx = find(ti1<0); ti1(idx) = ti1(idx)+65536;
ti2 = raw(3,:); idx = find(ti2<0); ti2(idx) = ti2(idx)+65536;
ti3 = raw(4,:); idx = find(ti3<0); ti3(idx) = ti3(idx)+65536;
y.time = (ti0 + 65536*(ti1 + 65536*(ti2 + 65536*ti3)))/25000;
y.channel = raw(5,:);
y.height = raw(6,:) .* (341/2048);
y.width = raw(7,:)/25;
y.context = raw(8:81,:);
y.thr = raw(82,:);
