function x = timer_isrunning(id)

global timer_data
if id<=0 || id>length(timer_data.period) || isnan(timer_data.period(id))
  error('Illegal timer ID');
end

x = ~isnan(timer_data.nextdue(id));
