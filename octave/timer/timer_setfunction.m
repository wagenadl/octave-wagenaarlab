function timer_setmode(id, fcn)
global timer_data
if id<=0 || id>length(timer_data.period) || isnan(timer_data.period(id))
  error('Illegal timer ID');
end

timer_data.fcn{id} = fcn;
