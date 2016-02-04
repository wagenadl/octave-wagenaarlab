function mode = timer_getmode(id)

global timer_data
if id<=0 || id>length(timer_data.period) || isnan(timer_data.period(id))
  error('Illegal timer ID');
end

mode = timer_data.execmode(id);
