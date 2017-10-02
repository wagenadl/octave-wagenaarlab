function sleepfrom(dt,t0)
% SLEEPFROM(dt,t0) sleeps DT seconds from T0, where T0 is a return value from NOW.

t_targ = t0*86400 + dt; % Target time
t_now = now*86400; % Current time
if t_targ > t_now
    pause(t_targ - t_now);
end
