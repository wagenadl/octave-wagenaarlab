function timer_poll
global timer_data

t = time();

ids = find(timer_data.nextdue < t);

if isempty(ids)
  return;
end

for id=ids(:)'
  try
    feval(timer_data.fcn{id});
    if timer_data.execmode(id)==0
      timer_data.nextdue(id) = timer_data.nextdue(id) + timer_data.period;
    else
      timer_data.nextdue(id) = nan;
    end
  catch
    fprintf(2, 'Error in timer function for ID #%i; stopping timer.\n', id);
    timer_stop(id);
  end
end

if all(isnan(timer_data.nextdue))
  timer_stoppolling();
end
