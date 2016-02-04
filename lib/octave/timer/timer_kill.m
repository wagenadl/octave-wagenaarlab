function timer_kill(id)
global timer_data
if id<=0 || id>length(timer_data.period) || isnan(timer_data.period(id))
  error('Illegal timer ID');
end

timer_data.period(id) = nan;
timer_data.nextdue(id) = nan;

timer_stoppolling();
