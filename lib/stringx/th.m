function s = th(x)
% TH - Return a string like 1st, 2nd, 3rd, etc.
%    s = TH(x) makes S be a string representation of the integer X:
%    1st, 2nd, 3rd, 4th, etc.

if x==11
  s = '11th';
elseif x==12
  s = '12th';
elseif x==13
  s = '13th';
elseif mod(x,10)==1
  s = sprintf('%ist', x);
elseif mod(x,10)==2
  s = sprintf('%ind', x);
elseif mod(x,10)==3
  s = sprintf('%ird', x);
else
  s = sprintf('%ith', x);
end

  
