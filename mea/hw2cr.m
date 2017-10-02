function [c,r]=hw2cr(hw)
% [c,r] = HW2CR(hw) converts the hardware channel number hw (0..63) to
% column and row numbers (1..8).
% cr = HW2CR(hw) converts the hardware channel number hw (0..63) to
% a 1+row+10*col format (11..88).
% hw may be a matrix, in which case the result is also a matrix.
% Illegal hardware numbers result in c,r == 0.

% matlab/hw2cr.m: part of meabench, an MEA recording and analysis tool
% Copyright (C) 2000-2002  Daniel Wagenaar (wagenaar@caltech.edu)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

badidx=(hw<0 | hw>63);
hw(badidx) = 64;
cols = [ 3, 3, 3, 3, 2, 2, 1, 2, 1, 0, 1, 0, 2, 1, 0, 0, 1, 2, 0, 1, ...
      0, 1, 2, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 6, 5, 6, 7, 6, ...
      7, 5, 6, 7, 7, 6, 5, 7, 6, 7, 6, 5, 6, 5, 5, 4, 4, 4, 4,  0, 7, ...
      0 ,7, -1 ];
rows = [  6, 7, 5, 4, 7, 6, 7, 5, 6, 6, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, ...
      1, 1, 2, 0, 1, 0, 3, 2, 0, 1, 1, 0, 2, 3, 0, 1, 0, 2, 1, 1, 2, ...
      2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 6, 5, 7, 6, 7, 4, 5, 7, 6,  0, 0, ...
      7, 7, -1 ];
c=11+10*cols(hw+1)+rows(hw+1);
if nargout>1
  r=mod(c,10);
  c=floor(c/10);
end
