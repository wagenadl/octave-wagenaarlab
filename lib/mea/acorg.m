function xc = acorg(ttx, dt, N)
% xc = ACORG(ttx, tty, dt, N) computes the auto-correlogram of a timeseries.
% TTX must be a vector of timestamps in non-decreasing order.
% Output will be 1 x N+1, corresponding to ttx == ttx + 0*dt ...
% ttx == tty + N*dt.

t0 = ttx(1);

ttx = uint32((ttx-t0)/dt);

xc = double(xcorg_int(ttx,ttx,N+1));
