function timer_setmode(id, mode)
% TIMER_SETMODE - Set running mode
%   TIMER_SETMODE(id, mode) sets the mode for timer ID to MODE.
%   MODE must be 0 for FixedRate, or 1 for SingleShot.

global timer_data
if id<=0 || id>length(timer_data.period) || isnan(timer_data.period(id))
  error('Illegal timer ID');
end

if mode==0 || mode==1
  timer_data.execmode(id) = mode;
else
  error('Illegal timer mode');
end
