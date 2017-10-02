function hw=cr2hw(c,r)
% hw = CR2HW(c,r) converts row and column to hardware channel number.
% c, r count from 1 to 8; hw counts from 0.
% hw = CR2HW(cr) converts combined row and column to hardware channel
% number. cr can be in the range 11..88.
% Illegal c, r values return -1.
% c, r or cr may be matrices, in which case the output is also a matrix.
% The dimensions of c, r must agree.

% matlab/cr2hw.m: part of meabench, an MEA recording and analysis tool
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


if nargin==1
  r=mod(c,10);
  c=floor(c./10);
end
badidx=~(c>=1 & c<=8 & r>=1 & r<=8); c(badidx)=1; r(badidx)=9;

mp = [ 60, 20, 18, 15, 14, 11, 9, 62, -1, -1, 23, 21, 19, 16, 13, 10, ...
      8, 6, -1, -1, 25, 24, 22, 17, 12, 7, 5, 4, -1, -1, 28, 29, 27, ...
      26, 3, 2, 0, 1, -1, -1, 31, 30, 32, 33, 56, 57, 59, 58, -1, -1, ...
      34, 35, 37, 42, 47, 52, 54, 55, -1, -1, 36, 38, 40, 43, 46, 49, ...
      51, 53, -1, -1, 61, 39, 41, 44, 45, 48, 50, 63, -1, -1 ];
hw=mp(10*(c-1)+r);

