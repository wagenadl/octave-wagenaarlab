function timer_startpolling

global timer_data
if isempty(timer_data.polling)
  timer_data.polling = add_input_event_hook('timer_poll');
end
