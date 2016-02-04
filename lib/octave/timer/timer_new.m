function id = timer_new(period_s, mode, fcn)
% TIMER_NEW - 
global timer_data
timer_init;

id = find(isnan(timer_data.period), 1);
if isempty(id)
  id = length(timer_data.period) + 1;
end

timer_data.execmode(id) = 1;
timer_data.period(id) = inf;
timer_data.nextdue(id) = inf;
timer_data.fcn{id} = fcn;

timer_setmode(id, mode);
timer_settimeout(id, period_s);
