function ss_rawinspect(vv, tt, tmin, tmax)
% SS_RAWINSPECT - Plot (a portion) of a raw trace
%    SS_RAWINSPECT(vv, tt) plots VV against TT.
%    SS_RAWINSPECT(vv, fs) constructs time vector from given sample freq.
%    SS_RAWINSPECT(vv, tt, tmax) plots from t=0 to TMAX
%    SS_RAWINSPECT(vv, tt, tmin, tmax) plots from t=TMIN to TMAX
%    TMIN and TMAX may also be a fraction (0<=TMIN<TMAX<1).

if length(tt)==1
  tt = [0:length(vv)-1]/tt;
else
  if any(diff(tt)<0)
    [vv, tt] = identity(tt, vv);
  end
end
if nargin<4
  if nargin<3
    tmax = tt(end);
  else
    tmax = tmin;
  end
  tmin = 0;
end
if tmax<1
  tmax = tmax*tt(end);
end
if tmin<1
  tmin = tmin*tt(end);
end

idx = find(tt>=tmin & tt<=tmax);
cla
plot(tt(idx), vv(idx));
xlabel 'Time (s)'
ylabel 'V (a.u.)'
