function y=axgrload(str,n)
% y = AXGRLOAD(str,n) loads file number N from axograph structure STR.
% STR must be the result of a function created by axgr2m.
% 
% Example:
%
%   str = mydata_050921;
%   y1 = axgrload(str,1);

if n==0
  fh = fopen(str.tfn,'rb');
  y = fread(fh,[1 inf],'float');
else
  fh = fopen(str.fn{n},'rb');
  y = fread(fh,[1 inf],'int16');
  fclose(fh);
  y = y * 10/32768;%str.yscale(n);
end
