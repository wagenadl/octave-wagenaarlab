function dt = latency(events, triggers)
% LATENCY - Calculate latency of events relative to triggers
%   dt = LATENCY(events, triggers) calculates the latency of each of the
%   EVENTS to the most closely preceding TRIGGER. (Event times and trigger
%   times can be in any units, typically seconds; DT will be in the same
%   units.) Both EVENTS and TRIGGERS must be sorted.

if ~isnvector(events)
  error('EVENTS must be a vector');
end
if ~isnvector(triggers) || prod(size(triggers))==0
  error('TRIGGERS must be a nonempty vector');
end

S = size(events);
events = double(events(:));
triggers = double(triggers(:));
dt = latency_core(events, triggers);
dt = reshape(dt, S);
