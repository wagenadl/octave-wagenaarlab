function y = readraw(fn, tp) 
% y=READRAW(fn) reads the raw MEA datafile fn and stores the result in y.

range = nan;

if nargin>=2
  if tp==1
    range = 341;
  elseif tp==2
    range = 520.833;
  else
    range = tp;
  end
end

fh = fopen(fn,'rb');
y = fread(fh,[64 inf],'int16');
fclose(fh);

if ~isnan(range)
  fprintf(2,'Converting for range %g uV [and %g mV]\n',range,range*1.2);
  y(1:60,:) = y(1:60,:) * range/2048;
  y(61:64,:)= y(61:64,:) * range/2048 * 1.2;
end
