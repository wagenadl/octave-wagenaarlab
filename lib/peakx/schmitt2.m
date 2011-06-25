function [on_a,off_a,on_b,off_b] = schmitt2(xx,thr_a,thr_b)
% [on_a,off_a,on_b,off_b] = SCHMITT2(xx,thr_a,thr_b) Schmitt triggers twice,
% once in the forward direction and one backwards.
% ON_A, OFF_A are the crossings through THR_A;
% ON_B, OFF_B are the crossings through THR_B.
% It is required that THR_B < THR_A.
%
% ON_A, OFF_A describe the broadest possible peak above THR_A;
% ON_B, OFF_B describe the narrowest possible peak above THR_B.
% (But ON_B,OFF_B describe wider peaks than ON_A,OFF_A, since THR_B<THR_A.)
%
% ON_A mark the first point where XX >= THR_A
% OFF_A mark the last point where XX >= THR_A
% ON_B mark the last point where XX < THR_B
% OFF_B mark the first point where XX < THR_B
%
% Note that if a peak extends past the end of the data, the final OFF_B 
% may be length(XX)+1. Likewise, the first ON_B may be zero. By contrast,
% the first ON_A cannot be less than 1 (though it can be 1), and the last
% OFF_A cannot be more than length(XX) (though it can be length(XX)).

xx=xx(:); N=length(xx);

[on_a, off_b] = schmitt(xx,thr_a,thr_b,2);

[off_a, on_b] = schmitt(flipud(xx),thr_a,thr_b,2);
off_a = flipud(N+1-off_a);
on_b = flipud(N+1-on_b);
