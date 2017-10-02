function str = num2thou(num, dec)
% NUM2THOU - Convert number to string with thousands separators
%   str = NUM2THOU(num, dec) converts NUM to a string with thousands 
%   separators with DEC decimal places. If DEC is not given, the default
%   is to create at least 5 significant digits and have the number of
%   decimal places be a multiple of 3 if it is more than 3 to begin with.
%   If NUM is not a scalar, the result is a cell array the size of NUM.

if nargin<2
  n0 = max(abs(num(:))+1e-99);
  l10 = ceil(log10(n0));
  dec = 5 - l10;
  if dec<0
    dec = 0;
  elseif dec>3
    dec = ceil(dec/3)*3;
  end
end

if isscalar(num)
  if num<0
    str = '-';
    num = -num;
  else
    str = '';
  end
  l10 = floor(log10(num+1e-99)/3)*3;
  if l10>=0
    for q=l10:-3:0
      v = floor(num/(10.^q));
      if q<l10
	str = [str sprintf(',%03.0f', v)];
      else
	str = [str sprintf('%.0f', v)];
      end
      num = num - v*10.^q;
    end
  else
    str = [str '0'];
  end
  if dec>0
    sep = '.';
    for q=0:3:dec-1
      now = min(3, dec-q);
      v = floor(num/10.^(-q-now));
      fmt = sprintf('%s%%0%i.0f', sep, now);
      str = [str sprintf(fmt, v)];
      num = num - v*10.^(-q-now);
      sep = ',';
    end
  end
else
  str = cell(size(num));
  for k=1:length(prod(size(num)))
    str{k} = num2thou(num(k));
  end
end