function day1=dateadd(day0,dv)
% DATEADD  Add a number of days to a date in the form YYMMDD.
%   day1 = DATEADD(day1,div) adds DIV to DAY0 to produce DAY1.
%   DAY0 should be of the form YYMMDD, or MMDD (but that's bad around 2/29).

if ischar(day0)
  L=length(day0);
  day0=atoi(day0);
else 
  if day0>991231
    L=8;
  elseif day0>1231
    L=6;
  else
    L=4;
  end
end

d0 = mod(day0,100);
m0 = mod(div(day0,100),100);
y0 = div(day0,100*100) + 2000;

n0 = datenum(y0,m0,d0);
n1 = n0 + dv;

day1 = datestr(n1,29);

y1 = day1(1:4);
m1 = day1(6:7);
d1 = day1(9:10);
if L==4
  day1 = [m1 d1];
elseif L==6
  day1 = [y1(3:4) m1 d1];
else
  day1 = [ y1 m1 d1];
end
