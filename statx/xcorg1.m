function [xc, dt] = xcorg1(ttx, tty, dt, N)
% XCORG1 - Correlogram for point processes
%    xc = XCORG1(ttx, tty, dt, N) computes half a correlogram between two 
%    point processes.
%    TTX and TTY must be vectors of timestamps in non-decreasing order.
%    Output will be 1 x N+1, corresponding to ttx == tty + 0 ...
%    ttx == tty + N*dt.
%    [xc, dt] = XCORG1(...) returns the time vector as well.

t0 = min([ttx(1) tty(1)]);

ttx = uint32((ttx-t0)/dt);
tty = uint32((tty-t0)/dt);

xc = double(xcorg_int(ttx,tty,N+1));

if nargout>=2
  dt = [0:N]*dt;
else
  clear dt
end
