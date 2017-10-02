function timer_settimeout(id, period_s)
global timer_data

if id<=0 || id>length(timer_data.period) || isnan(timer_data.period(id))
  error('Illegal timer ID');
end

if period_s < 0.1
  warning(sprintf('Period must be at least 0.1 s (not %g). Enforced.', period_s));
  period_s = 0.1;
end

timer_data.period(id) = period_s;

