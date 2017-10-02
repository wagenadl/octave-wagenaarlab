function y = shift(x,dt)
% SHIFT  Shift the rows of a matrix up or down.
%   y = SHIFT(x,dt) returns the matrix shifted by dt positions in the
%   first dimension.
%   If dt is positive, x(N,:) is shifted in at the bottom;
%   if dt is negative, x(1,:) is shifted in at the top.

N=size(x,1);
sh = [1:N]; sh=sh+dt;
sh(find(sh<1)) = 1;
sh(find(sh>N)) = N;
y = x(sh,:);
