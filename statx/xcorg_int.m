function xc = xcorg_int(ttx,tty,T)
% xc = XCORG_INT(ttx,tty,T) computes the cross-correlation between two
% time series TTX and TTY, which must be arrays of uint32s,
% pre-sorted in non-decreasing order. 
% Only the TTY-after-TTX part of the correlogram is calculated, and only
% the first T bins are, i.e. bins tty==ttx+0 up to tty==ttx+T-1.
% Output is always 1xT, irrespective of the shape of TTX or TTY.

error('This should have been implemented by a mex function');
