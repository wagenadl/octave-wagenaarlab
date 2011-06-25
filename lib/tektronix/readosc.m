function y = readosc(hw)
% y = READOSC(ch) reads oscilloscope data from channel CH (1..4)
% or MATH if (ch=0).
% Output is a structure with members:
%
%  tt: time of measurement points, in seconds
%  yy: value of measurement points, in volts
%  curv: raw return values from the CURV command
%  wfmp: raw return values from the WFMP command
%  dat:  raw return values from the DAT command
%
% If the "readosc" fails, than y.curv, tt, yy = [], other fields undef.

if hw==0
  hw = 'math';
else
  hw = [ 'ch' num2str(hw) ];
end

if unix([ 'readosc ' hw ' > /tmp/readosc.txt' ])
  y.curv = []
  y.tt=[];
  y.yy=[];
  return
end

fd = fopen('/tmp/readosc.txt','r');
while 1
  str = fgets(fd);
  if ~ischar(str)
    break
  end
  eval(str);
end
fclose(fd);
y.curv = curv;
y.wfmp = wfmp;
y.dat = dat;

y.tt = [0:y.wfmp.nr_p-1] * y.wfmp.xin + y.wfmp.xze;
y.yy = (y.curv-y.wfmp.yof)*y.wfmp.ymu + y.wfmp.yze;
