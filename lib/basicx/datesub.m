function dv=datesub(day1,day0)
% DATESUB  Subtract two dates in YYMMDD form to get number of days.
%   div = DATESUB(day1,day0) subtracts DAY0 from DAY1 to produce DIV.
%   DAYx should be of the form YYMMDD, or MMDD (but that's bad around 2/29).

if ischar(day0)
  day0=atoi(day0);
end

if ischar(day1)
  day1=atoi(day1);
end

d0 = mod(day0,100);
m0 = mod(div(day0,100),100);
y0 = div(day0,100*100) + 2000;

d1 = mod(day1,100);
m1 = mod(div(day1,100),100);
y1 = div(day1,100*100) + 2000;

n0 = datenum(y0,m0,d0);
n1 = datenum(y1,m1,d1);
dv = n1-n0;
