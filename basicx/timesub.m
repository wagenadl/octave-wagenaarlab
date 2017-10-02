function dt=timesub(tm1,tm0,dt)
% TIMESUB  Subtract two times in HHMM form to get number of hours
%    dt = TIMESUB(tm1,tm0) subtracts TM0 from TM1 to produce DT.
%    dt = TIMESUB(tm1,tm0,dt) then adds DT hours.
%    Answer is always a string in HHMM form

if ischar(tm1)
  tm1=atoi(tm1);
end
if ischar(tm0)
  tm0=atoi(tm0);
end
if nargin<3
  dt=0;
end

m0 = mod(tm0,100);
h0 = div(tm0,100);
m1 = mod(tm1,100);
h1 = div(tm1,100);

dt = dt + (h1-h0) + (m1-m0)/60;

sgn = sign(dt);
dt = abs(dt);
dh = floor(dt);
dm = floor((dt-dh)*60);

if sgn<0
  sgn='-';
else
  sgn='';
end
dt = sprintf('%s%02i:%02i',sgn,dh,dm);