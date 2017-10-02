function timer_init
% TIMER_INIT - Initialize timer system
%   TIMER_INIT initializes the timer system. It is OK to call it more than
%   once; secondary calls have no effect.
global timer_data
if ~isfield(timer_data, 'period')
  timer_data.execmode = []; % 1=once, 0=repeat
  timer_data.period = []; % nan for deleted timer
  timer_data.nextdue = []; % nan for single-shot that won't be due again
  timer_data.fcn = {};
  timer_data.polling = []; % empty if not polling, event_hook id if polling.
end
