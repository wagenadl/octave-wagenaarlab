function timer_stoppolling
% TIMER_STOPPOLLING - Stop polling if (and only if) it is no longer needed
global timer_data

if all(isnan(timer_data.nextdue))
  if ~isempty(timer_data.polling)
    remove_input_event_hook('timer_poll');  
    timer_data.polling = [];
  end
end
