function y = roll(x,dt)
% ROLL  Roll the rows of a matrix up or down.
%   y = ROLL(x,dt) returns the matrix rolled by dt positions in the
%   first dimension.
%   If dt is positive, x(1:dt,:) is shifted in at the bottom;
%   if dt is negative, x(N+dt:N,:) is shifted in at the top.

N=size(x,1);
sh = mod([1:N]+dt-1,N)+1;
y = x(sh,:);
