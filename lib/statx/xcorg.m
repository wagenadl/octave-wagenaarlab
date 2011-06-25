function [xc, dt] = xcorg(ttx, tty, dt, N)
% XCORG - Correlogram for point processes
%    xc = XCORG(ttx, tty, dt, N) computes a correlogram between two point 
%    processes with bin size DT and half-width N.
%    TTX and TTY must be vectors of timestamps in non-decreasing order.
%    Output will be 1 x 2*N+1, corresponding to TTX == TTY - N*DT ...
%    TTX == TTY + N*DT.
%    [xc, dt] = XCORG(...) returns the time vector as well.

t0 = min([ttx(1) tty(1)]);

ttx = uint32((ttx-t0)/dt);
tty = uint32((tty-t0)/dt+N);

xc = double(xcorg_int(ttx,tty,2*N+1));

if nargout>=2
  dt = [-N:N]*dt;
else
  clear dt
end
