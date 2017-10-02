function timer_start(id, period)
global timer_data
if id<=0 || id>length(timer_data.period) || isnan(timer_data.period(id))
  error('Illegal timer ID');
end

if nargin<2
  period = timer_data.period(id);
end

timer_data.nextdue(id) = time() + period;

timer_startpolling();
